#include "stdafx.h"
#include "script/ScriptCapture.h"

#include "rbx/threadsafe.h"
#include "boost/shared_ptr.hpp"
#include "reflection/Type.h"
#include "util/ProtectedString.h"
#include "v8tree/Instance.h"

#include <stdio.h>
#include <string.h>

namespace RBX
{
	namespace ScriptCapture
	{
		namespace
		{
			// Function-local so construction happens on first emit, after
			// the CRT and logging are up (never as a static initializer).
			RBX::mutex& lock()
			{
				static RBX::mutex instance;
				return instance;
			}

			FILE* g_file = NULL;
			bool g_tried = false;
			long g_seq = 0;

			FILE* sink()
			{
				if (g_file || g_tried)
					return g_file;
				g_tried = true;
				char path[MAX_PATH];
				if (::GetEnvironmentVariableA("RBX_CAPTURE_PATH", path, MAX_PATH) == 0)
					return NULL;
				g_file = ::fopen(path, "w");
				if (g_file)
					rbx_setCaptureActive(1);
				return g_file;
			}

			void writeJsonString(FILE* f, const char* s)
			{
				::fputc('"', f);
				for (const char* p = s; *p; ++p)
				{
					switch (*p)
					{
					case '"': ::fputs("\\\"", f); break;
					case '\\': ::fputs("\\\\", f); break;
					case '\n': ::fputs("\\n", f); break;
					case '\r': ::fputs("\\r", f); break;
					case '\t': ::fputs("\\t", f); break;
					default:
						if ((unsigned char)*p < 0x20)
							::fprintf(f, "\\u%04x", *p);
						else
							::fputc(*p, f);
					}
				}
				::fputc('"', f);
			}
		}

		bool active()
		{
			RBX::mutex::scoped_lock guard(lock());
			return sink() != NULL;
		}

		void emit(const char* hook, const std::string& detail)
		{
			emit(hook, detail.c_str());
		}

		void emit(const char* hook, const char* detail)
		{
			if (!hook || !detail)
				return;
			RBX::mutex::scoped_lock guard(lock());
			FILE* f = sink();
			if (!f)
				return;
			// Flushed per line so a later crash never loses earlier events.
			::fprintf(f, "{\"seq\":%ld,\"ts_ms\":%lu,\"tid\":%lu,\"hook\":\"%s\",",
				++g_seq, (unsigned long)::GetTickCount(), (unsigned long)::GetCurrentThreadId(), hook);
			::fputs("\"detail\":", f);
			writeJsonString(f, detail);
			::fputs("}\n", f);
			::fflush(f);
		}

		namespace
		{
			// Strings longer than this are truncated with a <N more> marker.
			const size_t kMaxString = 512;

			std::string quotedTruncated(const char* s, size_t len)
			{
				std::string out = "\"";
				size_t n = len < kMaxString ? len : kMaxString;
				for (size_t i = 0; i < n; ++i)
				{
					char c = s[i];
					if (c == '"')
						out += "\\\"";
					else if (c == '\\')
						out += "\\\\";
					else if (c == '\n')
						out += "\\n";
					else if (c >= 0x20)
						out += c;
					else
					{
						char esc[8];
						snprintf(esc, sizeof(esc), "\\x%02x", (unsigned char)c);
						out += esc;
					}
				}
				out += "\"";
				if (len > kMaxString)
				{
					char tail[32];
					snprintf(tail, sizeof(tail), "...<%u more>", (unsigned)(len - kMaxString));
					out += tail;
				}
				return out;
			}
		}

		std::string luaValueString(lua_State* L, int idx)
		{
			if (!L)
				return "null-state";
			if (idx <= 0 && idx > LUA_REGISTRYINDEX)
				idx = lua_gettop(L) + idx + 1;
			switch (lua_type(L, idx))
			{
			case LUA_TNIL:
				return "nil";
			case LUA_TBOOLEAN:
				return lua_toboolean(L, idx) ? "true" : "false";
			case LUA_TNUMBER:
				{
					char buf[32];
					snprintf(buf, sizeof(buf), "%g", lua_tonumber(L, idx));
					return buf;
				}
			case LUA_TSTRING:
				{
					size_t len = 0;
					const char* s = lua_tolstring(L, idx, &len);
					return s ? quotedTruncated(s, len) : "null-string";
				}
			case LUA_TFUNCTION:
				return "function";
			case LUA_TTHREAD:
				return "thread";
			case LUA_TTABLE:
				return "table";
			case LUA_TUSERDATA:
			case LUA_TLIGHTUSERDATA:
				if (lua_getmetatable(L, idx))
				{
					std::string t = "userdata";
					lua_getfield(L, -1, "__type");
					if (lua_type(L, -1) == LUA_TSTRING)
						t = "userdata:" + std::string(lua_tostring(L, -1));
					lua_pop(L, 2);
					return t;
				}
				return "userdata";
			default:
				return "?";
			}
		}

		std::string valueString(const Reflection::Variant& v)
		{
			if (v.isType<void>())
				return "nil";
			if (v.isType<bool>())
				return v.cast<bool>() ? "true" : "false";
			if (v.isType<int>())
			{
				char buf[32];
				snprintf(buf, sizeof(buf), "%d", v.cast<int>());
				return buf;
			}
			if (v.isType<long>())
			{
				char buf[32];
				snprintf(buf, sizeof(buf), "%ld", v.cast<long>());
				return buf;
			}
			if (v.isType<float>())
			{
				char buf[32];
				snprintf(buf, sizeof(buf), "%g", (double)v.cast<float>());
				return buf;
			}
			if (v.isType<double>())
			{
				char buf[32];
				snprintf(buf, sizeof(buf), "%g", v.cast<double>());
				return buf;
			}
			if (v.isType<std::string>())
			{
				const std::string& s = v.cast<std::string>();
				return quotedTruncated(s.c_str(), s.size());
			}
			if (v.isType<RBX::ProtectedString>())
			{
				const std::string& s = v.cast<RBX::ProtectedString>().getSource();
				return "source" + quotedTruncated(s.c_str(), s.size());
			}
			if (v.isType<boost::shared_ptr<Instance> >())
			{
				boost::shared_ptr<Instance> inst = v.cast<boost::shared_ptr<Instance> >();
				if (!inst)
					return "Instance<null>";
				return "Instance<" + inst->getClassNameStr() + ":" + inst->getName() + ">";
			}
			return std::string("<") + v.type().tag.c_str() + ">";
		}

		std::string tupleString(const Reflection::Tuple& t, size_t maxVals)
		{
			std::string out;
			size_t n = t.values.size() < maxVals ? t.values.size() : maxVals;
			for (size_t i = 0; i < n; ++i)
			{
				if (i)
					out += ",";
				out += valueString(t.values[i]);
			}
			if (t.values.size() > maxVals)
			{
				char tail[32];
				snprintf(tail, sizeof(tail), ",...<%u more>", (unsigned)(t.values.size() - maxVals));
				out += tail;
			}
			return out;
		}

		namespace
		{
			void coverageOut(void* ctx, const char* chunk, int linedefined, int sizecode, int exec, const char* offs)
			{
				(void)ctx;
				char head[128];
				snprintf(head, sizeof(head), "chunk=%s proto=%d exec=%d/%d offs=",
					chunk ? chunk : "?", linedefined, exec, sizecode);
				emit("coverage", std::string(head) + (offs ? offs : ""));
			}

			void traceOut(void* ctx, const char* chunk, int linedefined, int op, int line, unsigned w0, unsigned w1)
			{
				(void)ctx;
				char head[192];
				snprintf(head, sizeof(head), "chunk=%s proto=%d op=%d line=%d w0=%u w1=%u",
					chunk ? chunk : "?", linedefined, op, line, w0, w1);
				emit("trace", head);
			}
		}

		void dumpCoverage()
		{
			rbx_dumpCoverage(NULL, coverageOut);
		}

		void dumpTrace()
		{
			rbx_dumpTrace(NULL, traceOut);
		}
	}
}
