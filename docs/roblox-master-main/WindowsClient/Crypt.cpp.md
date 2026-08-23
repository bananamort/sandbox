# WindowsClient/Crypt.cpp

## Purpose

Authenticode signature verification for downloaded/patched binaries, built on the classic MSDN "SignedFileInfo" sample (a commented-out `_tmain` at lines 384–572 is the sample's original entry point). Exported `VerifyCryptSignature` runs three gates: WinVerifyTrust embedded-signature check, PKCS#7 signer-info attribute check (program name + info URL), and a certificate pin (exact 16-byte serial number + issuer/subject display names). Linked via `#pragma comment(lib, "crypt32.lib")` and `(lib, "wintrust")`.

## API

Real signatures:

- `bool VerifyCryptSignature(const std::wstring& fileName)` — exported; SEH-style `__try/__finally` with cleanup of store/msg/cert contexts. Sequence:
  1. `VerifyEmbeddedSignature(szFileName)` must return true.
  2. `CryptQueryObject(CERT_QUERY_OBJECT_FILE, ..., CERT_QUERY_CONTENT_FLAG_PKCS7_SIGNED_EMBED, CERT_QUERY_FORMAT_FLAG_BINARY, ...)` → hStore/hMsg; then two `CryptMsgGetParam(hMsg, CMSG_SIGNER_INFO_PARAM, 0, ...)` calls (size + data).
  3. If `GetProgAndPublisherInfo(pSignerInfo, &ProgPubInfo)`: requires `StrCmpW(ProgPubInfo.lpszProgramName, L"Roblox Application") == 0` AND `StrCmpW(ProgPubInfo.lpszMoreInfoLink, L"http://www.roblox.com ") == 0` — **note the trailing space** in the URL string, matched verbatim from the signing OpusInfo.
  4. `CertFindCertificateInStore(..., CERT_FIND_SUBJECT_CERT, &CertInfo, NULL)` on issuer+serial.
  5. `VerifyCertificateInfo(pCertContext)` must pass ⇒ result=true.
  Timestamp verification block is fully commented out (`GetTimeStampSignerInfo` path).
- `bool VerifyEmbeddedSignature(LPCWSTR pwszSourceFile)` — file-local. `WinVerifyTrust(NULL, &WINTRUST_ACTION_GENERIC_VERIFY_V2, &WinTrustData)` with `WTD_UI_NONE`, `WTD_REVOKE_NONE`, `dwProvFlags = WTD_SAFER_FLAG`. **Return mapping is deliberately loose**: ERROR_SUCCESS → true; TRUST_E_NOSIGNATURE → false (both sub-branches); TRUST_E_EXPLICIT_DISTRUST → **true**; TRUST_E_SUBJECT_NOT_TRUSTED → true; CRYPT_E_SECURITY_SETTINGS → true; default (chain errors) → true; unreachable trailing `return true`. Only "definitely unsigned" fails here — the strict pinning happens in VerifyCertificateInfo.
- `bool VerifyCertificateInfo(PCCERT_CONTEXT pCertContext)` — file-local; the actual trust anchor:
  - Builds expected strings through per-character concatenation (string-obfuscation against binary grep): issuer `"Sym"+"ant"+"ec "+"Cla"+"ss "+"3 S"+"HA2"+"56 "+"Cod"+"e S"+"ign"+"ing"+" CA"` (= "Symantec Class 3 SHA256 Code Signing CA"); subject `"R"+"O"+"B"+"L"+"O"+"X"+" C"+"or"+"por"+"at"+"io"+"n"` (= "ROBLOX Corporation"). Both are `static std::string` re-initialized each call.
  - Serial must be exactly 16 bytes and byte-equal to the hardcoded array: pbData[15..0] = 1B 81 59 FA F8 22 8B 39 AB C0 0E 31 BB AD 43 09 (comment: "signature is taken from current version of RobloxApp file"; displayed order reversed).
  - Issuer simple-display name (`CERT_NAME_ISSUER_FLAG`) compared `szName != issuerNameToCheck`; subject name likewise vs nameToCheck.
- `BOOL GetProgAndPublisherInfo(PCMSG_SIGNER_INFO, PSPROG_PUBLISHERINFO)` — decodes SPC_SP_OPUS_INFO_OBJID authenticated attribute (MSDN sample verbatim).
- `BOOL GetDateOfTimeStamp(PCMSG_SIGNER_INFO, SYSTEMTIME*)` / `BOOL GetTimeStampSignerInfo(PCMSG_SIGNER_INFO, PCMSG_SIGNER_INFO*)` — szOID_RSA_signingTime / szOID_RSA_counterSign decoders; only referenced from the commented-out blocks (dead in current build).
- `LPWSTR AllocateAndCopyWideString(LPCWSTR)` — LocalAlloc helper.

## Usage

The patch/update flow verifies a freshly written exe before swapping it in; see ReleasePatcher.cpp for the call site and the failure policy. Any sandbox rebuild that self-verifies will fail this pin — the serial number belongs to Roblox's real Symantec cert and cannot be reproduced by a test signer.

## Gotchas

- Inverted-looking returns in VerifyEmbeddedSignature: explicit-distrust / not-trusted / unknown chain errors all count as "verified" (true). Combined with the exact serial pin, effective security = serial match; everything else is theater.
- `szName != issuerNameToCheck` compares `LPTSTR` against `std::string` — compiles only when TCHAR == char (MBCS build); under UNICODE it would not even compile, so WindowsClient must be built MultiByte.
- The pinned certificate expired long ago in the real world (Symantec Class 3 SHA256); on modern machines chain errors land in the `default: return true` bucket, which is precisely why the loose mapping exists.
- `#include "Util/MD5Hasher.h"` present but no MD5 symbol is used — dead include.
- `GetProgAndPublisherInfo` prints failures via `_tprintf` to stdout in a windowed app (invisible).
