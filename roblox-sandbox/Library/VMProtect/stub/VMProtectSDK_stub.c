// Auto-generated stub of VMProtectSDK.dll export surface.
#include <windows.h>

// Layout opaque here; callers use the full SDK header. Only parameter
// sizes matter for x86 stdcall decoration.
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
	return FALSE;
}

BOOL __stdcall VMProtectIsVirtualMachinePresent(void)
{
	return FALSE;
}

BOOL __stdcall VMProtectIsValidImageCRC(void)
{
	return TRUE;
}

BOOL __stdcall VMProtectFreeString(void *value)
{
	return FALSE;
}

INT __stdcall VMProtectSetSerialNumber(const char * SerialNumber)
{
	return 0;
}

INT __stdcall VMProtectGetSerialNumberState(void)
{
	return 0;
}

INT __stdcall VMProtectGetSerialNumberData(VMProtectSerialNumberData *pData, UINT nSize)
{
	return 0;
}

INT __stdcall VMProtectGetCurrentHWID(char * HWID, UINT nSize)
{
	return 0;
}

INT __stdcall VMProtectActivateLicense(const char *code, char *serial, int size)
{
	return 0;
}

INT __stdcall VMProtectDeactivateLicense(const char *serial)
{
	return 0;
}

INT __stdcall VMProtectGetOfflineActivationString(const char *code, char *buf, int size)
{
	return 0;
}

INT __stdcall VMProtectGetOfflineDeactivationString(const char *serial, char *buf, int size)
{
	return 0;
}
