#include "stdafx.h"
#include "script/ScriptCapture.h"

#include "../Lua-5.1.4/src/VM/include/lua.h"
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

		void writeFieldVal(FILE* f, const FieldVal& v)
		{
			switch (v.kind)
			{
			case FieldVal::Str:
				writeJsonString(f, v.s.c_str());
				break;
			case FieldVal::Int:
				::fprintf(f, "%lld", v.i);
				break;
			case FieldVal::Dbl:
				{
					char buf[32];
					snprintf(buf, sizeof(buf), "%g", v.d);
					::fputs(buf, f);
				}
				break;
			case FieldVal::Bool:
				::fputs(v.b ? "true" : "false", f);
				break;
			case FieldVal::Nil:
				::fputs("null", f);
				break;
			case FieldVal::Arr:
				::fputc('[', f);
				for (size_t i = 0; i < v.a.size(); ++i)
				{
					if (i)
						::fputc(',', f);
					writeFieldVal(f, v.a[i]);
				}
				::fputc(']', f);
				break;
			case FieldVal::Obj:
				::fputc('{', f);
				for (size_t i = 0; i < v.o.size(); ++i)
				{
					if (i)
						::fputc(',', f);
					writeJsonString(f, v.o[i].key);
					::fputc(':', f);
					writeFieldVal(f, v.o[i].val);
				}
				::fputc('}', f);
				break;
			}
		}

		void emitFields(const char* hook, const std::string& detail,
			const std::vector<Field>& fields)
		{
			emitFields(hook, detail.c_str(), fields);
		}

		void emitFields(const char* hook, const char* detail,
			const std::vector<Field>& fields)
		{
			if (!hook || !detail)
				return;
			RBX::mutex::scoped_lock guard(lock());
			FILE* f = sink();
			if (!f)
				return;
			::fprintf(f, "{\"seq\":%ld,\"ts_ms\":%lu,\"tid\":%lu,\"hook\":\"%s\",",
				++g_seq, (unsigned long)::GetTickCount(), (unsigned long)::GetCurrentThreadId(), hook);
			::fputs("\"detail\":", f);
			writeJsonString(f, detail);
			for (size_t i = 0; i < fields.size(); ++i)
			{
				::fputc(',', f);
				writeJsonString(f, fields[i].key);
				::fputc(':', f);
				writeFieldVal(f, fields[i].val);
			}
			::fputs("}\n", f);
			::fflush(f);
		}

		namespace
		{
			// Strings longer than this are truncated with a <N more> marker.
			const size_t kMaxString = 512;

			// Escaped inner text shared by the quoted renderer and the
			// typed raw payload, so both stay byte-identical.
			std::string escapeInner(const char* s, size_t len, bool* truncated)
			{
				std::string out;
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
				if (truncated)
					*truncated = len > kMaxString;
				return out;
			}
		}

		TypedValue luaValueTyped(lua_State* L, int idx)
		{
			TypedValue t;
			t.truncated = false;
			if (!L)
			{
				t.kind = "nil";
				return t;
			}
			if (idx <= 0 && idx > LUA_REGISTRYINDEX)
				idx = lua_gettop(L) + idx + 1;
			switch (lua_type(L, idx))
			{
			case LUA_TNIL:
				t.kind = "nil";
				return t;
			case LUA_TBOOLEAN:
				t.kind = "bool";
				t.raw = lua_toboolean(L, idx) ? "true" : "false";
				return t;
			case LUA_TNUMBER:
			case LUA_TINTEGER:
				{
					t.kind = "number";
					char buf[32];
					snprintf(buf, sizeof(buf), "%g", lua_tonumber(L, idx));
					t.raw = buf;
					return t;
				}
#if !LUA_VECTOR_DOUBLE
			case LUA_TVECTOR:
				t.kind = "vector";
				return t;
#endif
			case LUA_TSTRING:
				{
					size_t len = 0;
					const char* s = lua_tolstring(L, idx, &len);
					if (!s)
					{
						t.kind = "nil";
						return t;
					}
					t.kind = "string";
					t.raw = escapeInner(s, len, &t.truncated);
					return t;
				}
			case LUA_TFUNCTION:
				t.kind = "function";
				return t;
			case LUA_TTHREAD:
				t.kind = "thread";
				return t;
			case LUA_TTABLE:
				t.kind = "table";
				return t;
			case LUA_TUSERDATA:
			case LUA_TLIGHTUSERDATA:
				t.kind = "userdata";
				if (lua_getmetatable(L, idx))
				{
					lua_getfield(L, -1, "__type");
					if (lua_type(L, -1) == LUA_TSTRING)
						t.raw = lua_tostring(L, -1);
					lua_pop(L, 2);
				}
				return t;
			default:
				t.kind = "?";
				return t;
			}
		}

		std::string luaValueString(lua_State* L, int idx)
		{
			if (!L)
				return "null-state";
			TypedValue t = luaValueTyped(L, idx);
			if (t.kind == "string")
			{
				std::string out = "\"" + t.raw + "\"";
				if (t.truncated)
				{
					// Length suffix needs the original length, which the
					// truncating renderer already computed; recompute here
					// from the stack value so output stays identical.
					size_t len = 0;
					if (lua_tolstring(L, idx, &len) && len > kMaxString)
					{
						char tail[32];
						snprintf(tail, sizeof(tail), "...<%u more>", (unsigned)(len - kMaxString));
						out += tail;
					}
				}
				return out;
			}
			if (t.kind == "bool" || t.kind == "number")
				return t.raw;
			if (t.kind == "userdata")
				return t.raw.empty() ? "userdata" : "userdata:" + t.raw;
			if (t.kind == "nil")
			{
				// Preserve the legacy null-string marker for a NULL
				// payload; plain nil stays "nil".
				size_t len = 0;
				if (lua_type(L, idx) == LUA_TSTRING && !lua_tolstring(L, idx, &len))
					return "null-string";
				return "nil";
			}
			return t.kind == "?" ? "?" : t.kind;
		}

		TypedValue valueTyped(const Reflection::Variant& v)
		{
			TypedValue t;
			t.truncated = false;
			if (v.isType<void>())
			{
				t.kind = "nil";
				return t;
			}
			if (v.isType<bool>())
			{
				t.kind = "bool";
				t.raw = v.cast<bool>() ? "true" : "false";
				return t;
			}
			if (v.isType<int>())
			{
				t.kind = "number";
				char buf[32];
				snprintf(buf, sizeof(buf), "%d", v.cast<int>());
				t.raw = buf;
				return t;
			}
			if (v.isType<long>())
			{
				t.kind = "number";
				char buf[32];
				snprintf(buf, sizeof(buf), "%ld", v.cast<long>());
				t.raw = buf;
				return t;
			}
			if (v.isType<float>())
			{
				t.kind = "number";
				char buf[32];
				snprintf(buf, sizeof(buf), "%g", (double)v.cast<float>());
				t.raw = buf;
				return t;
			}
			if (v.isType<double>())
			{
				t.kind = "number";
				char buf[32];
				snprintf(buf, sizeof(buf), "%g", v.cast<double>());
				t.raw = buf;
				return t;
			}
			if (v.isType<std::string>())
			{
				const std::string& s = v.cast<std::string>();
				t.kind = "string";
				t.raw = escapeInner(s.c_str(), s.size(), &t.truncated);
				return t;
			}
			if (v.isType<RBX::ProtectedString>())
			{
				const std::string& s = v.cast<RBX::ProtectedString>().getSource();
				t.kind = "source";
				t.raw = escapeInner(s.c_str(), s.size(), &t.truncated);
				return t;
			}
			if (v.isType<boost::shared_ptr<Instance> >())
			{
				boost::shared_ptr<Instance> inst = v.cast<boost::shared_ptr<Instance> >();
				t.kind = "instance";
				if (inst)
					t.raw = inst->getClassNameStr() + ":" + inst->getName();
				return t;
			}
			t.kind = v.type().tag.c_str();
			return t;
		}

		std::string valueString(const Reflection::Variant& v)
		{
			TypedValue t = valueTyped(v);
			if (t.kind == "string")
			{
				std::string out = "\"" + t.raw + "\"";
				if (t.truncated)
				{
					const std::string& s = v.cast<std::string>();
					char tail[32];
					snprintf(tail, sizeof(tail), "...<%u more>", (unsigned)(s.size() - kMaxString));
					out += tail;
				}
				return out;
			}
			if (t.kind == "source")
			{
				std::string out = "source\"" + t.raw + "\"";
				if (t.truncated)
				{
					const std::string& s = v.cast<RBX::ProtectedString>().getSource();
					char tail[32];
					snprintf(tail, sizeof(tail), "...<%u more>", (unsigned)(s.size() - kMaxString));
					out += tail;
				}
				return out;
			}
			if (t.kind == "instance")
				return t.raw.empty() ? "Instance<null>" : "Instance<" + t.raw + ">";
			if (t.kind == "nil" || t.kind == "bool" || t.kind == "number")
				return t.raw.empty() ? "nil" : t.raw;
			return "<" + t.kind + ">";
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
			void coverageOut(void* ctx, const char* chunk, int linedefined, int sizecode, int exec, const int* offs, int noffs)
			{
				(void)ctx;
				std::string offText;
				std::vector<FieldVal> offArr;
				for (int i = 0; i < noffs; ++i)
				{
					if (i)
						offText += ',';
					char num[16];
					snprintf(num, sizeof(num), "%d", offs[i]);
					offText += num;
					offArr.push_back(FieldVal::num(offs[i]));
				}
				char head[128];
				snprintf(head, sizeof(head), "chunk=%s proto=%d exec=%d/%d offs=%s",
					chunk ? chunk : "?", linedefined, exec, sizecode, offText.c_str());
				std::vector<Field> fields;
				fields.push_back({"chunk", FieldVal::str(chunk ? chunk : "?")});
				fields.push_back({"proto", FieldVal::num(linedefined)});
				fields.push_back({"sizecode", FieldVal::num(sizecode)});
				fields.push_back({"exec", FieldVal::num(exec)});
				fields.push_back({"offs", FieldVal::arr(offArr)});
				emitFields("coverage", head, fields);
			}

			void traceOut(void* ctx, const char* chunk, int linedefined, int op, int line, unsigned w0, unsigned w1)
			{
				(void)ctx;
				char head[192];
				snprintf(head, sizeof(head), "chunk=%s proto=%d op=%d line=%d w0=%u w1=%u",
					chunk ? chunk : "?", linedefined, op, line, w0, w1);
				std::vector<Field> fields;
				fields.push_back({"chunk", FieldVal::str(chunk ? chunk : "?")});
				fields.push_back({"proto", FieldVal::num(linedefined)});
				fields.push_back({"op", FieldVal::num(op)});
				fields.push_back({"line", FieldVal::num(line)});
				fields.push_back({"w0", FieldVal::num((long long)w0)});
				fields.push_back({"w1", FieldVal::num((long long)w1)});
				emitFields("trace", head, fields);
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

		namespace
		{
			void constOut(void* ctx, const char* chunk, int linedefined, int op, const char* kind, const char* value, int truncated)
			{
				(void)ctx;
				char head[128];
				snprintf(head, sizeof(head), "chunk=%s proto=%d op=%d %s=",
					chunk ? chunk : "?", linedefined, op, kind ? kind : "?");
				std::vector<Field> fields;
				fields.push_back({"chunk", FieldVal::str(chunk ? chunk : "?")});
				fields.push_back({"proto", FieldVal::num(linedefined)});
				fields.push_back({"op", FieldVal::num(op)});
				fields.push_back({"kind", FieldVal::str(kind ? kind : "?")});
				fields.push_back({"value", FieldVal::str(value ? value : "")});
				fields.push_back({"truncated", FieldVal::boolean(truncated != 0)});
				emitFields("const", std::string(head) + (value ? value : ""), fields);
			}
		}

		void dumpConsts()
		{
			rbx_dumpConsts(NULL, constOut);
		}
	}
}
