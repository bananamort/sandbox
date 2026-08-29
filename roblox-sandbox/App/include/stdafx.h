/* Copyright 2003-2005 ROBLOX Corporation, All Rights Reserved */

#pragma once

// WS4-C5: C++17 removed std::auto_ptr. The shim below aliases it to
// std::unique_ptr (same move-only semantics) so the 2016 engine
// headers continue to compile. The shim is in ../../include so the
// path resolves from any App/* sub-project.
#include "auto_ptr_compat.h"
#include "cpp_compat.h"

#include <vector>
#include <map>

#include "rbx/boost.hpp"
#include "rbx/threadsafe.h"
#include "rbx/signal.h"
#include "rbx/TaskScheduler.Job.h"

#include <boost/unordered_map.hpp>
#include <boost/function.hpp>

#include "util/Name.h"
#include "util/Region3.h"
#include "reflection/YieldFunction.h"
#include "v8tree/Instance.h"
#include "V8DataModel/DataModel.h"


