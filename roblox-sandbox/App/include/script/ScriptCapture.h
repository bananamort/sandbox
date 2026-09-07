#pragma once

#include <string>

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

		// Drains the VM inline coverage map into "coverage" records
		// (one per executed proto). No-op without an open capture.
		void dumpCoverage();

		// Drains the VM instruction ring into "trace" records
		// (newest slice, bounded). No-op without an open capture.
		void dumpTrace();
	}
}
