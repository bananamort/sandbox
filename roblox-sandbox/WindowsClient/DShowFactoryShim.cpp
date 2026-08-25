// DirectShow base-class contract: strmbase.lib's dllentry.obj references the
// consumer's class-factory registry. WindowsClient implements no COM server;
// supply the empty table the library requires.
#include "stdafx.h"
#include <streams.h>

CFactoryTemplate g_Templates[1];
int g_cTemplates = 0;
