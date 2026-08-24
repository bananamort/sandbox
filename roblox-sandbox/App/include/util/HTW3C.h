#pragma once

extern "C" {
#ifndef _WIN32
#include <wwwsys.h>
#endif

#include <HTParse.h>
}

// HTParse.h #defines PARSE_ANCHOR (to PARSE_VIEW, i.e. the constant 2) as
// part of the libwww URL-parse flag set. Windows' urlmon.h -- reached later
// in this TU through <atlutil.h> -- declares an ENUMERATOR also named
// PARSE_ANCHOR inside _tagPARSEACTION; the macro turns that line into
// "2 = ( ... )" and shreds the whole header (C2143 at urlmon.h(6688),
// then unknown PARSEACTION, brace-rot into propidl.h). Nothing in this
// tree uses libwww's PARSE_ANCHOR/PARSE_VIEW/PARSE_FRAGMENT flags (call
// sites only pass PARSE_ACCESS / PARSE_HOST / PARSE_PATH to HParse), so
// drop the poisoned name here, right where the libwww surface is exposed.
// Doing it in this wrapper keeps the fix independent of SDK/ATL include
// order: if urlmon.h parsed first there is nothing to undo.
#undef PARSE_ANCHOR
