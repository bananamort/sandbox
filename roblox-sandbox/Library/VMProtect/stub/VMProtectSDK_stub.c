void __stdcall VMProtectBegin(const char *)
{

}

void __stdcall VMProtectBeginVirtualization(const char *)
{

}

void __stdcall VMProtectBeginMutation(const char *)
{

}

void __stdcall VMProtectBeginUltra(const char *)
{

}

void __stdcall VMProtectBeginVirtualizationLockByKey(const char *)
{

}

void __stdcall VMProtectBeginUltraLockByKey(const char *)
{

}

void __stdcall VMProtectEnd(void)
{

}

BOOL __stdcall VMProtectIsDebuggerPresent(BOOL)
{

    return 0;
}

BOOL __stdcall VMProtectIsVirtualMachinePresent(void)
{

    return 0;
}

BOOL __stdcall VMProtectIsValidImageCRC(void)
{

    return 0;
}

BOOL __stdcall VMProtectFreeString(void *value)
{

    return 0;
}

INT __stdcall VMProtectSetSerialNumber(const char * SerialNumber)
{

    return 0;
}

INT __stdcall VMProtectGetSerialNumberState(void)
{

    return 0;
}

BOOL __stdcall VMProtectGetSerialNumberData(VMProtectSerialNumberData *pData, UINT nSize)
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
