#include "stdafx.h"
#include "script/LuaVM.h"

#include "util/Guid.h"
#include "util/ProtectedString.h"

#include "util/MD5Hasher.h"
#include "v8datamodel/DataModel.h"
#include "v8datamodel/HackDefines.h"

#define LUAVM_DESERIALIZER
#include "LuaSerializer.inl"

struct CoreScriptBytecode
{
    const char* name;
    const unsigned char* value;
    size_t dataSize;
};

#include "LuaGenCS.inl"

// WS4-C5: removed 5.1.4 luaY_parser dummy. Luau has its own parser
// (Luau::Parser) accessible via luau_parse; the 5.1.4 stub that took
// ZIO*/Mbuffer* is no longer referenced and the 5.1.4 internal types
// ZIO/Mbuffer do not exist in Luau 0.735.
