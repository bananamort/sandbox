#include "stdafx.h"
#include "script/ScriptCapture.h"

#include "rbx/threadsafe.h"

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
	}
}
