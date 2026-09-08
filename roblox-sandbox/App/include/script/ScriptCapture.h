#pragma once

#include <string>
#include <vector>

struct lua_State;

// Single capture stream for WS5 instrumentation (ARCHITECTURE.md §5).
// Every hook below Lua emits one JSONL record per event through emit().
// Disabled unless the RBX_CAPTURE_PATH environment variable names a file;
// with it unset all calls are a single branch and do no work, so normal
// builds and smoke runs are unaffected.
namespace RBX
{
	namespace Reflection { class Variant; struct Tuple; }

	namespace ScriptCapture
	{
		// Records {"seq","ts_ms","tid","hook","detail"}. detail is plain
		// text; the sink escapes it. Safe to call from any engine thread.
		void emit(const char* hook, const std::string& detail);
		void emit(const char* hook, const char* detail);

		// Typed field for machine-readable records. Rendered as real JSON
		// types (string/int/bool/array), never parsed back out of text:
		// offline tools read keys, not detail.
		struct Field;
		struct FieldVal
		{
			enum Kind { Str, Int, Dbl, Bool, Arr, Obj, Nil } kind;
			std::string s;
			long long i;
			double d;
			bool b;
			std::vector<FieldVal> a;
			std::vector<Field> o;
			static FieldVal str(const char* v) { FieldVal f; f.kind = Str; f.s = v ? v : ""; return f; }
			static FieldVal str(const std::string& v) { FieldVal f; f.kind = Str; f.s = v; return f; }
			static FieldVal num(long long v) { FieldVal f; f.kind = Int; f.i = v; return f; }
			static FieldVal dbl(double v) { FieldVal f; f.kind = Dbl; f.d = v; return f; }
			static FieldVal boolean(bool v) { FieldVal f; f.kind = Bool; f.b = v; return f; }
			static FieldVal arr(std::vector<FieldVal> v) { FieldVal f; f.kind = Arr; f.a = v; return f; }
			static FieldVal obj(std::vector<Field> v) { FieldVal f; f.kind = Obj; f.o = v; return f; }
			static FieldVal nil() { FieldVal f; f.kind = Nil; return f; }
		};
		struct Field
		{
			const char* key;
			FieldVal val;
		};

		// Typed emit: detail stays as the human summary line; fields carry
		// every machine-consumed datum as real JSON. New hooks must use
		// this; plain emit() is legacy for human-only lines.
		void emitFields(const char* hook, const std::string& detail,
			const std::vector<Field>& fields);
		void emitFields(const char* hook, const char* detail,
			const std::vector<Field>& fields);

		// True once a capture file was successfully opened.
		bool active();

		// Value rendering for reconstruction payloads. All three are
		// side-effect-free and truncate long strings:
		// - luaValueString renders the Lua value at stack index idx
		//   (nil/boolean/number/string verbatim; userdata by metatable
		//   __type; function/thread/table by kind).
		// - valueString renders a reflection Variant (nil/bool/numbers/
		//   strings verbatim; Instance as Class:Name; else type tag).
		// - tupleString renders up to maxVals Tuple values, comma-joined.
		std::string luaValueString(lua_State* L, int idx);
		std::string valueString(const Reflection::Variant& v);
		std::string tupleString(const Reflection::Tuple& t, size_t maxVals = 8);

		// Typed value rendering. kind is one of nil/bool/number/string/
		// function/thread/table/vector/userdata/userdata:TYPE/lightuserdata/?,
		// raw is the unadorned payload (string contents unquoted, numbers
		// plain, userdata the metatable __type or empty). truncated is set
		// when raw was cut at kMaxString. The string renderers above are
		// thin wrappers and stay for human detail lines.
		struct TypedValue
		{
			std::string kind;
			std::string raw;
			bool truncated;
		};
		TypedValue luaValueTyped(lua_State* L, int idx);
		TypedValue valueTyped(const Reflection::Variant& v);

		// Typed value as a FieldVal object {kind, value, truncated} for
		// machine-readable records. kind/value come straight from the
		// TypedValue above — never re-parsed from rendered text.
		static inline FieldVal luaValueField(lua_State* L, int idx)
		{
			TypedValue t = luaValueTyped(L, idx);
			std::vector<Field> o;
			o.push_back({"kind", FieldVal::str(t.kind)});
			o.push_back({"value", FieldVal::str(t.raw)});
			o.push_back({"truncated", FieldVal::boolean(t.truncated)});
			return FieldVal::obj(o);
		}
		static inline FieldVal valueField(const Reflection::Variant& v)
		{
			TypedValue t = valueTyped(v);
			std::vector<Field> o;
			o.push_back({"kind", FieldVal::str(t.kind)});
			o.push_back({"value", FieldVal::str(t.raw)});
			o.push_back({"truncated", FieldVal::boolean(t.truncated)});
			return FieldVal::obj(o);
		}

		// Drains the VM inline coverage map into "coverage" records
		// (one per executed proto). No-op without an open capture.
		void dumpCoverage();

		// Drains the VM instruction ring into "trace" records
		// (newest slice, bounded). No-op without an open capture.
		void dumpTrace();

		// Drains the VM constant-resolution ring into "const" records
		// (chunk/proto/op/kind/value, typed). No-op without capture.
		void dumpConsts();
	}
}
