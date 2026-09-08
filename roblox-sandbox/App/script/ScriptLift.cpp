#include "stdafx.h"
#include "script/ScriptLift.h"
#include "script/ScriptCapture.h"

#include "Luau/Parser.h"
#include "Luau/PrettyPrinter.h"
#include "Luau/Allocator.h"
#include "Luau/Lexer.h"

#include "rbx/threadsafe.h"

#include <stdio.h>

namespace RBX
{
	namespace ScriptLift
	{
		namespace
		{
			RBX::mutex& lock()
			{
				static RBX::mutex instance;
				return instance;
			}

			struct ConstRec
			{
				int proto;
				int off;
				int op;
				std::string kind;
				std::string value;
			};

			struct ChunkData
			{
				std::string source;
				int exec;
				int total;
				bool hasCoverage;
				std::vector<ConstRec> consts;
				ChunkData() : exec(0), total(0), hasCoverage(false) {}
			};

			typedef std::map<std::string, ChunkData> ChunkMap;

			ChunkMap& chunks()
			{
				static ChunkMap map;
				return map;
			}
		}

		void noteChunk(const std::string& chunk, const std::string& source)
		{
			RBX::mutex::scoped_lock guard(lock());
			chunks()[chunk].source = source;
		}

		void noteConst(const std::string& chunk, int proto, int off, int op,
			const std::string& kind, const std::string& value)
		{
			RBX::mutex::scoped_lock guard(lock());
			ConstRec r;
			r.proto = proto;
			r.off = off;
			r.op = op;
			r.kind = kind;
			r.value = value;
			chunks()[chunk].consts.push_back(r);
		}

		void noteCoverage(const std::string& chunk, int proto, int exec, int total)
		{
			(void)proto;
			RBX::mutex::scoped_lock guard(lock());
			ChunkData& c = chunks()[chunk];
			c.exec += exec;
			c.total += total;
			c.hasCoverage = true;
		}

		bool reconstruct(const std::string& outPath)
		{
			RBX::mutex::scoped_lock guard(lock());
			FILE* f = ::fopen(outPath.c_str(), "w");
			if (!f)
				return false;
			bool ok = true;
			int nchunks = 0;
			for (ChunkMap::iterator it = chunks().begin(); it != chunks().end(); ++it)
			{
				const std::string& name = it->first;
				ChunkData& c = it->second;
				++nchunks;
				::fprintf(f, "-- chunk: %s coverage=%d/%d\n",
					name.c_str(), c.exec, c.total);
				if (c.source.empty())
				{
					::fprintf(f, "-- ERROR: no source logged\n");
					ok = false;
					continue;
				}
				try
				{
					Luau::Allocator allocator;
					Luau::AstNameTable names(allocator);
					Luau::ParseResult res = Luau::Parser::parse(
						c.source.c_str(), c.source.size(), names, allocator);
					if (!res.errors.empty() || !res.root)
					{
						::fprintf(f, "-- ERROR: parse failed: %s\n",
							res.errors.empty() ? "no root" : res.errors[0].getMessage().c_str());
						ok = false;
						continue;
					}
					std::string code = Luau::prettyPrint(*res.root);
					::fputs(code.c_str(), f);
					::fputc('\n', f);
				}
				catch (const std::exception& e)
				{
					::fprintf(f, "-- ERROR: exception: %s\n", e.what());
					ok = false;
				}
			}
			::fclose(f);
			char head[128];
			snprintf(head, sizeof(head), "chunks=%d ok=%d", nchunks, ok ? 1 : 0);
			std::vector<RBX::ScriptCapture::Field> fields;
			fields.push_back({"chunks", RBX::ScriptCapture::FieldVal::num(nchunks)});
			fields.push_back({"ok", RBX::ScriptCapture::FieldVal::boolean(ok)});
			RBX::ScriptCapture::emitFields("lift", head, fields);
			return ok && nchunks > 0;
		}
	}
}
