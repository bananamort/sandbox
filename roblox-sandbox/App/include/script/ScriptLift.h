#pragma once

#include <string>

// Offline-in-process lifter (WS5/T1.6.10): rebuilds runnable Luau from
// the capture stream using Luau's own Parser + PrettyPrinter — no
// regex, no text scraping. Fed with typed data straight from the
// instrumentation (never rendered text); variable names are preserved
// as-is (renaming belongs to the separate renamer tool).
namespace RBX
{
	namespace ScriptLift
	{
		void noteChunk(const std::string& chunk, const std::string& source);
		void noteConst(const std::string& chunk, int proto, int off, int line, int op,
			const std::string& kind, const std::string& value);
		void noteCoverage(const std::string& chunk, int proto, int exec, int total);
		// Executed source line for the annotate pass: constant-time lookup
		// built from coverage bitmaps at reconstruct() time.
		void noteExecLine(const std::string& chunk, int line);

		// Parses every noted chunk and pretty-prints it to outPath with a
		// coverage header per chunk. Returns false if any chunk fails to
		// parse (logged sources always parsed to run, so failure is a
		// real defect, never papered over).
		bool reconstruct(const std::string& outPath);
	}
}
