#include "stdafx.h"
#include "script/ScriptLift.h"
#include "script/ScriptCapture.h"

#include "Luau/Parser.h"
#include "Luau/PrettyPrinter.h"
#include "Luau/Allocator.h"
#include "Luau/Lexer.h"
#include "Luau/Bytecode.h"

#include "rbx/threadsafe.h"

#include <stdio.h>
#include <string.h>

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
				int line;
				int op;
				std::string kind;
				std::string value;
			};

			struct ValueEntry
			{
				// kind: same vocabulary as the const ring
				// (nil/bool/number/string/import/other).
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
				// Observed literal values by line, from GETGLOBAL const
				// resolution at record time: line -> rendered literal.
				// Only lines actually observed executing carry entries;
				// annotation-only, never deletion.
				std::map<int, ValueEntry> values;
				// Executed source lines (from trace records).
				std::map<int, bool> execLines;
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

		void noteConst(const std::string& chunk, int proto, int off, int line, int op,
			const std::string& kind, const std::string& value)
		{
			RBX::mutex::scoped_lock guard(lock());
			ConstRec r;
			r.proto = proto;
			r.off = off;
			r.line = line;
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

		void noteExecLine(const std::string& chunk, int line)
		{
			RBX::mutex::scoped_lock guard(lock());
			chunks()[chunk].execLines[line] = true;
		}

		// Render one observed constant to a Luau literal, or empty when
		// the kind is not a literal (function/thread/table/userdata,
		// import paths, truncated strings): substitution only ever
		// inserts literals, exactly like 5.1.4 constant folding did.
		static bool renderLiteral(const std::string& kind, const std::string& value,
			std::string& out)
		{
			if (kind == "nil")
			{
				out = "nil";
				return true;
			}
			if (kind == "bool")
			{
				if (value == "true" || value == "false")
				{
					out = value;
					return true;
				}
				return false;
			}
			if (kind == "number")
			{
				// Const ring renders via %g; accept back only what parses
				// the same way (no NaN/inf forms, no trailing junk).
				char* end = NULL;
				(void)strtod(value.c_str(), &end);
				if (end && *end == 0 && strcmp(value.c_str(), "nan") != 0 &&
					strncmp(value.c_str(), "inf", 3) != 0 && strncmp(value.c_str(), "-inf", 4) != 0)
				{
					out = value;
					return true;
				}
				return false;
			}
			if (kind == "string")
			{
				// The record value is already the escaped payload; wrap in
				// double quotes exactly as the sink renderer did.
				out = "\"" + value + "\"";
				return true;
			}
			return false;
		}

		// Substitute globals resolved live at record time: the visitor
		// carries the current source line; each AstExprGlobal on a line
		// with exactly one GETGLOBAL observation group for the line
		// becomes the observed literal. Conflict or non-literal: untouched.
		class ConstSubstVisitor : public Luau::AstVisitor
		{
		public:
			int nsubst;
			ConstSubstVisitor(Luau::Allocator& alloc,
				std::map<int, std::vector<const ConstRec*> >& getByLine)
				: names(alloc), getByLine(getByLine), nsubst(0),
				  substTarget(NULL), substWith(NULL) {}

			bool visit(Luau::AstExprGlobal* node)
			{
				if (!node->name.value)
					return true;
				int line = node->location.begin.line + 1;
				std::map<int, std::vector<const ConstRec*> >::iterator it =
					getByLine.find(line);
				if (it == getByLine.end() || it->second.size() != 1)
					return true;
				const ConstRec* r = it->second[0];
				Luau::AstExpr* replacement = NULL;
				if (r->kind == "nil")
				{
					replacement = names.alloc<Luau::AstExprConstantNil>(node->location);
				}
				else if (r->kind == "bool")
				{
					if (r->value == "true" || r->value == "false")
						replacement = names.alloc<Luau::AstExprConstantBool>(
							node->location, r->value == "true");
				}
				else if (r->kind == "number")
				{
					char* end = NULL;
					double d = strtod(r->value.c_str(), &end);
					if (end && *end == 0)
						replacement = names.alloc<Luau::AstExprConstantNumber>(
							node->location, d);
				}
				else if (r->kind == "string")
				{
					Luau::AstArray<char> arr;
					arr.data = const_cast<char*>(r->value.c_str());
					arr.size = r->value.size();
					replacement = names.alloc<Luau::AstExprConstantString>(
						node->location, arr,
						Luau::AstExprConstantString::QuoteStyle::QuotedSimple);
				}
				if (replacement)
				{
					// First match wins this round; the driver loop
					// replaces and re-walks for the next one.
					substTarget = node;
					substWith = replacement;
					return false;
				}
				return true;
			}

			Luau::AstExpr* substTarget;
			Luau::AstExpr* substWith;

		private:
			Luau::Allocator& names;
			std::map<int, std::vector<const ConstRec*> >& getByLine;
		};

		static bool replaceExpr(Luau::AstStatBlock* block, Luau::AstExpr* target,
			Luau::AstExpr* with);
		static bool replaceExprImpl(Luau::AstStatBlock* block, Luau::AstExpr* target,
			Luau::AstExpr* with);

		static bool replaceInExpr(Luau::AstExpr*& slot, Luau::AstExpr* target,
			Luau::AstExpr* with)
		{
			if (slot == target)
			{
				slot = with;
				return true;
			}
			if (!slot)
				return false;
			if (Luau::AstExprGroup* g = slot->as<Luau::AstExprGroup>())
				return replaceInExpr(g->expr, target, with);
			else if (Luau::AstExprCall* c = slot->as<Luau::AstExprCall>())
			{
				if (replaceInExpr(c->func, target, with))
					return true;
				for (size_t i = 0; i < c->args.size; ++i)
				{
					if (replaceInExpr(c->args.data[i], target, with))
						return true;
				}
				return false;
			}
			else if (Luau::AstExprIndexName* n = slot->as<Luau::AstExprIndexName>())
				return replaceInExpr(n->expr, target, with);
			else if (Luau::AstExprIndexExpr* n = slot->as<Luau::AstExprIndexExpr>())
			{
				if (replaceInExpr(n->expr, target, with))
					return true;
				return replaceInExpr(n->index, target, with);
			}
			else if (Luau::AstExprFunction* fn = slot->as<Luau::AstExprFunction>())
				return replaceExprImpl(fn->body, target, with);
			else if (Luau::AstExprTable* tb = slot->as<Luau::AstExprTable>())
			{
				for (size_t i = 0; i < tb->items.size; ++i)
				{
					if (tb->items.data[i].key && replaceInExpr(tb->items.data[i].key, target, with))
						return true;
					if (replaceInExpr(tb->items.data[i].value, target, with))
						return true;
				}
				return false;
			}
			else if (Luau::AstExprUnary* u = slot->as<Luau::AstExprUnary>())
				return replaceInExpr(u->expr, target, with);
			else if (Luau::AstExprBinary* b = slot->as<Luau::AstExprBinary>())
			{
				if (replaceInExpr(b->left, target, with))
					return true;
				return replaceInExpr(b->right, target, with);
			}
			else if (Luau::AstExprTypeAssertion* ta = slot->as<Luau::AstExprTypeAssertion>())
				return replaceInExpr(ta->expr, target, with);
			else if (Luau::AstExprInstantiate* in = slot->as<Luau::AstExprInstantiate>())
				return replaceInExpr(in->expr, target, with);
			else if (Luau::AstExprIfElse* ie = slot->as<Luau::AstExprIfElse>())
			{
				if (replaceInExpr(ie->condition, target, with))
					return true;
				if (replaceInExpr(ie->trueExpr, target, with))
					return true;
				return replaceInExpr(ie->falseExpr, target, with);
			}
			else if (Luau::AstExprInterpString* is = slot->as<Luau::AstExprInterpString>())
			{
				for (size_t i = 0; i < is->expressions.size; ++i)
				{
					if (replaceInExpr(is->expressions.data[i], target, with))
						return true;
				}
				return false;
			}
			return false;
		}

		// Replace one expression node inside a block tree by pointer
		// identity. Returns true when replaced. Walks every expression
		// position (statements, calls, tables, functions, if/while,
		// for/for-in/repeat/return) so a resolved name is substituted
		// wherever it appears, not just top-level value slots.
		static bool replaceExpr(Luau::AstStatBlock* block, Luau::AstExpr* target,
			Luau::AstExpr* with)
		{
			return replaceExprImpl(block, target, with);
		}

		static bool replaceExprImpl(Luau::AstStatBlock* block, Luau::AstExpr* target,
			Luau::AstExpr* with)
		{
			for (size_t i = 0; i < block->body.size; ++i)
			{
				Luau::AstStat* st = block->body.data[i];
				if (Luau::AstStatExpr* e = st->as<Luau::AstStatExpr>())
				{
					if (replaceInExpr(e->expr, target, with))
						return true;
				}
				else if (Luau::AstStatLocal* l = st->as<Luau::AstStatLocal>())
				{
					for (size_t j = 0; j < l->values.size; ++j)
					{
						if (replaceInExpr(l->values.data[j], target, with))
							return true;
					}
				}
				else if (Luau::AstStatAssign* a = st->as<Luau::AstStatAssign>())
				{
					for (size_t j = 0; j < a->vars.size; ++j)
					{
						if (replaceInExpr(a->vars.data[j], target, with))
							return true;
					}
					for (size_t j = 0; j < a->values.size; ++j)
					{
						if (replaceInExpr(a->values.data[j], target, with))
							return true;
					}
				}
				else if (Luau::AstStatReturn* r = st->as<Luau::AstStatReturn>())
				{
					for (size_t j = 0; j < r->list.size; ++j)
					{
						if (replaceInExpr(r->list.data[j], target, with))
							return true;
					}
				}
				else if (Luau::AstStatFor* f = st->as<Luau::AstStatFor>())
				{
					if (replaceInExpr(f->from, target, with))
						return true;
					if (f->step && replaceInExpr(f->step, target, with))
						return true;
					if (replaceInExpr(f->to, target, with))
						return true;
					if (replaceExprImpl(f->body, target, with))
						return true;
				}
				else if (Luau::AstStatForIn* fi = st->as<Luau::AstStatForIn>())
				{
					for (size_t j = 0; j < fi->values.size; ++j)
					{
						if (replaceInExpr(fi->values.data[j], target, with))
							return true;
					}
					if (replaceExprImpl(fi->body, target, with))
						return true;
				}
				else if (Luau::AstStatRepeat* rp = st->as<Luau::AstStatRepeat>())
				{
					if (replaceExprImpl(rp->body, target, with))
						return true;
					if (replaceInExpr(rp->condition, target, with))
						return true;
				}
				else if (Luau::AstStatFunction* fn = st->as<Luau::AstStatFunction>())
				{
					if (replaceInExpr(fn->name, target, with))
						return true;
					Luau::AstExpr* fbody = fn->func;
					if (replaceInExpr(fbody, target, with))
					{
						fn->func = fbody->as<Luau::AstExprFunction>();
						return true;
					}
				}
				else if (Luau::AstStatLocalFunction* lf = st->as<Luau::AstStatLocalFunction>())
				{
					Luau::AstExpr* fbody = lf->func;
					if (replaceInExpr(fbody, target, with))
					{
						lf->func = fbody->as<Luau::AstExprFunction>();
						return true;
					}
				}
				else if (Luau::AstStatCompoundAssign* ca = st->as<Luau::AstStatCompoundAssign>())
				{
					if (replaceInExpr(ca->var, target, with))
						return true;
					if (replaceInExpr(ca->value, target, with))
						return true;
				}
				else if (Luau::AstStatIf* cond = st->as<Luau::AstStatIf>())
				{
					if (replaceInExpr(cond->condition, target, with))
						return true;
					if (replaceExprImpl(cond->thenbody, target, with))
						return true;
					if (cond->elsebody)
					{
						if (Luau::AstStatBlock* eb = cond->elsebody->as<Luau::AstStatBlock>())
						{
							if (replaceExprImpl(eb, target, with))
								return true;
						}
						else if (Luau::AstStatIf* ei = cond->elsebody->as<Luau::AstStatIf>())
						{
							// elseif chain: wrap single statement as block.
							Luau::AstStatBlock tmp(cond->elsebody->location, Luau::AstArray<Luau::AstStat*>());
							tmp.body.data = &cond->elsebody;
							tmp.body.size = 1;
							if (replaceExprImpl(&tmp, target, with))
								return true;
						}
					}
				}
				else if (Luau::AstStatWhile* w = st->as<Luau::AstStatWhile>())
				{
					if (replaceInExpr(w->condition, target, with))
						return true;
					if (replaceExprImpl(w->body, target, with))
						return true;
				}
			}
			return false;
		}

		// Coverage annotation: tag branch statements whose body lines
		// never executed. Never deletes: the analyst sees what ran.
		class CoverageAnnotateVisitor : public Luau::AstVisitor
		{
		public:
			CoverageAnnotateVisitor(std::map<int, bool>& execLines)
				: execLines(execLines) {}

			bool visit(Luau::AstStatIf* node)
			{
				annotateBlock(node->thenbody, "then");
				if (node->elsebody)
				{
					if (Luau::AstStatBlock* eb = node->elsebody->as<Luau::AstStatBlock>())
						annotateBlock(eb, "else");
				}
				return true;
			}

			bool visit(Luau::AstStatWhile* node)
			{
				annotateBlock(node->body, "loop-body");
				return true;
			}

		private:
			void annotateBlock(Luau::AstStatBlock* block, const char* tag)
			{
				bool anyExec = false;
				for (size_t i = 0; i < block->body.size; ++i)
				{
					int line = block->body.data[i]->location.begin.line;
					if (execLines.find(line) != execLines.end())
					{
						anyExec = true;
						break;
					}
				}
				if (!anyExec)
					coldTags.push_back(std::string(tag));
			}

		public:
			std::map<int, bool>& execLines;
			std::vector<std::string> coldTags;
		};

		bool reconstruct(const std::string& outPath)
		{
			RBX::mutex::scoped_lock guard(lock());
			FILE* f = ::fopen(outPath.c_str(), "w");
			if (!f)
				return false;
			bool ok = true;
			int nchunks = 0;
			int nsubst = 0;
			for (ChunkMap::iterator it = chunks().begin(); it != chunks().end(); ++it)
			{
				const std::string& name = it->first;
				ChunkData& c = it->second;
				++nchunks;
				::fprintf(f, "-- chunk: %s coverage=%d/%d consts=%u\n",
					name.c_str(), c.exec, c.total, (unsigned)c.consts.size());
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
					// GETGLOBAL const records carry the live-resolved
					// value of the global at execution line r.line. Match
					// AstExprGlobal nodes on the same source line by name,
					// in order: the i-th distinct global read on that line
					// takes the i-th GETGLOBAL record for the line.
					// Literals only, exact kind matches; a second distinct
					// value for the same name marks conflict (no guess).
					std::map<int, std::vector<const ConstRec*> > getByLine;
					for (size_t i = 0; i < c.consts.size(); ++i)
					{
						const ConstRec& r = c.consts[i];
						if (r.op != LOP_GETGLOBAL) // resolved global reads; others are future work
							continue;
						std::string lit;
						if (!renderLiteral(r.kind, r.value, lit))
							continue;
						getByLine[r.line].push_back(&c.consts[i]);
					}
					// Substitution pass: walk top-level statements in
					// order; for each AstExprGlobal on a line with exactly
					// one GETGLOBAL observation group, replace with the
					// literal when kinds line up. Conflict (two distinct
					// values, same name+line) or non-literal: leave alone.
					// bridgeGetValue records carry the pre-write setValue
					// the same way (write merged at the anchored read);
					// property reads resolve identically.
					int nsubst = 0;
					{
						// Repeat: each visit finds one match (visitor holds
						// single target), replaceExpr applies it, loop until
						// no more matches. Bounded by const count.
						for (size_t round = 0; round < c.consts.size() + 1; ++round)
						{
							ConstSubstVisitor sub(allocator, getByLine);
							for (size_t i = 0; i < res.root->body.size; ++i)
								res.root->body.data[i]->visit(&sub);
							if (!sub.substTarget || !sub.substWith)
								break;
							if (!replaceExprImpl(res.root, sub.substTarget, sub.substWith))
								break;
							++nsubst;
						}
					}
					::fprintf(f, "-- subst=%d\n", nsubst);
					// First pass: annotate coverage.
					CoverageAnnotateVisitor cover(c.execLines);
					res.root->visit(&cover);
					for (size_t i = 0; i < cover.coldTags.size(); ++i)
						::fprintf(f, "-- note: %s never executed\n",
							cover.coldTags[i].c_str());
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
