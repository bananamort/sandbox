# WindowsClient/WebBrowserAxDialog.cpp

## Purpose

Implements the IE-hosted upload dialogs. OnInitDialog grabs the IDC_EXPLORER1 control as `SHDocVw::IWebBrowserAppPtr`, advises both DWebBrowserEvents connection points, and Navigates to the caller URL. The page's JavaScript reaches back through `window.external` (GetExternal returns the dialog itself) into five mapped names, and navigation is policy-filtered via `Http::trustCheckBrowser`. Video upload posts multipart/related directly to the 2016-era YouTube GData API with a **hardcoded developer key**.

## API

Real signatures / behavior:

- Ctors: `WebBrowserAxDialog(const std::string& url, shared_ptr<DataModel> dataModel [, boost::function<void(bool)> enableUpload])` — m_cRef=1, siteSEO=false; only the 3-arg form receives the enable-upload callback.
- `LRESULT OnInitDialog(UINT, WPARAM, LPARAM, BOOL&)` — CenterWindow; IDI_WINDOW_ICON icons; `GetDlgControl(IDC_EXPLORER1, __uuidof(SHDocVw::IWebBrowserAppPtr), ...)`; FindConnectionPoint(DWebBrowserEvents/DWebBrowserEvents2) + Advise(&m_events); `pWebBrowser->Navigate(_bstr_t(url.c_str()))`; failure ⇒ MessageBox "Failed to open web browser" and return FALSE.
- `LRESULT OnClose(...)` — `EndDialog(IDCANCEL)`.
- `HRESULT GetIDsOfNames(...)` — maps exactly five external names to dispIDs: "CheckAppHost"→0 (never handled in Invoke), "AppHostOpenVideoFolder"→1, "AppHostUploadVideo"→2, "AppHostOpenPicFolder"→3, "AppHostPostImage"→4. Unknown names leave rgDispId[0] untouched (garbage risk).
- `HRESULT Invoke(DISPID, ...)` — DISPATCH_METHOD only: 1 ⇒ `ShellExecuteW(open, <user Videos dir>)`; 2 ⇒ unpacks args REVERSED from rgvarg ([0]=title BSTR, [1]=postSetting iVal, [2]=doPost iVal, [3]=token BSTR) → `UploadVideo(token, doPost, postSetting, title)` — local typo variable `tile` verbatim; 3 ⇒ open Pictures dir; 4 ⇒ `GameSettings::singleton().setPostImageSetting(NEVER)` ("Do not show this window again").
- `void UploadVideo(std::string token, SHORT doPost, SHORT postSetting, std::string title)` — persists upload setting to GameBasicSettings; if doPost==1 calls DoUploadVideo with `dataModel->getVideoSEOInfo()` when `isVideoSEOInfoSet()` else "".
- `void DoUploadVideo(std::string token, std::string title, std::string seostr, int placeId)` — empty seostr ⇒ siteSEO=false and default SEO text `format_string("To play this game, please visit: http://www.roblox.com/item.aspx?id=%d&amp;rbx_source=youtube&amp;rbx_medium=uservideo", placeId)` (placeId>0); else siteSEO=true with server-supplied SEO XML. Default title "ROBLOX ROCKS!" (typo `titelString` on the way). `enableUpload(false)` then fires detached `boost::thread(ThreadDoUploadVideo, ...)`.
- `DWORD ThreadDoUploadVideo(shared_ptr<DataModel>, bool siteSEO, std::string videoTitle, std::string videoSEOInfo, std::string fileName, std::string youtubeToken, boost::function<void(bool)> enableUpload)` — builds a multipart body (boundary `f93dcbA3`): Atom entry (`<media:title>` etc., category Games, keywords "ROBLOX, video, free game, online virtual world", footer "For more games visit http://www.roblox.com") + raw AVI file; siteSEO path splices videoTitle between `titlePrefix/titlePostfix` tags of the server XML instead. POSTs to hardcoded `http://uploads.gdata.youtube.com/feeds/api/users/default/uploads` with headers Authorization AuthSub token, GData-Version 2, **X-GData-Key: key=AI39si5sZKe6qAobFgnT9UFGXq9bBO7mUCsK3_cWy_LJmgKDtl-GOMHNNV_Bh7Jk7KqDX7vI8D30jFHwnu8RJcDmcJN47yPW7A** (embedded developer key), Slug roblox.avi. Success heuristic: response contains "videoid" ("TODO: better way of checking"). On-screen status via CoreGuiService::displayOnScreenMessage; always enableUpload(true).
- `void DoPostImage(std::string filename, std::string seostr)` — same POST flow as ScreenshotVerb::uploadScreenshot (`<BaseUrl>/UploadMedia/DoPostImage.ashx?from=client`, whitespace-SEO header trick) duplicated here with its own static PostImageFinished.
- IDocHostUIHandler: GetHostInfo ORs DOCHOSTUIFLAG_NO3DBORDER | ROBLOX_BROWSERFLAGS (DISABLE_HELP_MENU, ENABLE_FORMS_AUTOCOMPLETE, THEME, DISABLE_SCRIPT_INACTIVE, LOCAL_MACHINE_ACCESS_CHECK, DISABLE_UNTRUSTEDPROTOCOL); ShowContextMenu returns E_NOTIMPL (default menu suppressed by E_NOTIMPL? actually MSHTML treats non-S_OK as "host did not handle"... behavior kept as-is); **GetExternal** returns this ⇒ window.external.
- DWebBrowserEventsImpl::Invoke — DISPID_BEFORENAVIGATE/BEFORENAVIGATE2 → BeforeNavigate2 does `RBX::Http::trustCheckBrowser(convert_w2s(URL)) ? S_OK : E_FAIL` (Cancel semantics via failure HRESULT); DISPID_NAVIGATECOMPLETE → NavigateComplete sets ICustomDoc::SetUIHandler(m_cpParent) so host flags apply; DISPID_WINDOWCLOSING → sets cancel VARIANT_TRUE and EndDialog(IDCANCEL). AddRef returns 1, Release returns 0 (static-lifetime sink).

## Usage

Modal lifecycle: constructed on UI thread with target URL, `DoModal()` (optionally parented to View HWND), destroyed on close. The YouTube endpoint died years ago — video upload is dead-in-production code but still compiles and will attempt network POSTs.

## Gotchas

- The hardcoded YouTube developer key and AuthSub flow are live secrets in source; any sandbox egress proxy should expect these exact hosts/headers or stub them.
- Argument order in Invoke dispID 2 is rgvarg-reversed (BSTR/iVal/iVal/BSTR) — must match the JS caller's push order exactly.
- GetIDsOfNames compares only `*rgszNames` (first name) and ignores cNames.
- ThreadDoUploadVideo reads the whole video through stringstream in memory before posting — multi-hundred-MB captures inflate RSS twice.
- Duplicate near-identical upload logic exists in GameVerbs.cpp (PostImageFinished ×2) — divergence hazard when editing either.
