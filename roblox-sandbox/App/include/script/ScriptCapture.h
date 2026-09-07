#pragma once

#include <string>

// Single capture stream for WS5 instrumentation (ARCHITECTURE.md §5).
// Every hook below Lua emits one JSONL record per event through emit().
// Disabled unless the RBX_CAPTURE_PATH environment variable names a file;
// with it unset all calls are a single branch and do no work, so normal
// builds and smoke runs are unaffected.
namespace RBX
{
	namespace ScriptCapture
	{
		// Records {"seq","ts_ms","tid","hook","detail"}. detail is plain
		// text; the sink escapes it. Safe to call from any engine thread.
		void emit(const char* hook, const std::string& detail);
		void emit(const char* hook, const char* detail);

		// True once a capture file was successfully opened.
		bool active();
	}
}
