// Auto-generated stub of VMProtectSDK.dll export surface.
// Parameters given synthetic names for MSVC C compilation.
#include <windows.h>

// Layout opaque here; callers use the full SDK header. Size only affects
// nothing at runtime since the stub bodies ignore parameters.
typedef struct { unsigned int nState; } VMProtectSerialNumberData;

void __stdcall VMProtectBegin(const char * arg0)
{
}

void __stdcall VMProtectBeginVirtualization(const char * arg0)
{
}

void __stdcall VMProtectBeginMutation(const char * arg0)
{
}

void __stdcall VMProtectBeginUltra(const char * arg0)
{
}

void __stdcall VMProtectBeginVirtualizationLockByKey(const char * arg0)
{
}

void __stdcall VMProtectBeginUltraLockByKey(const char * arg0)
{
}

void __stdcall VMProtectEnd(void)
{
}

BOOL __stdcall VMProtectIsDebuggerPresent(BOOL arg0)
{
}

BOOL __stdcall VMProtectIsVirtualMachinePresent(void)
{
}

BOOL __stdcall VMProtectIsValidImageCRC(void)
{
}

BOOL __stdcall VMProtectFreeString(void *value)
{
}

INT __stdcall VMProtectSetSerialNumber(const char * SerialNumber)
{
}

INT __stdcall VMProtectGetSerialNumberState(void)
{
}

BOOL __stdcall VMProtectGetSerialNumberData(VMProtectSerialNumberData *pData, UINT nSize)
{
}

INT __stdcall VMProtectGetCurrentHWID(char * HWID, UINT nSize)
{
}

INT __stdcall VMProtectActivateLicense(const char *code, char *serial, int size)
{
}

INT __stdcall VMProtectDeactivateLicense(const char *serial)
{
}

INT __stdcall VMProtectGetOfflineActivationString(const char *code, char *buf, int size)
{
}

INT __stdcall VMProtectGetOfflineDeactivationString(const char *serial, char *buf, int size)
{
}
