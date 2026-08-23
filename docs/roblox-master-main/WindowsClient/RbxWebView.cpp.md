# WindowsClient/RbxWebView.cpp

## Purpose

Implements the in-game URL window. OnInitDialog hosts the IDC_RBXEXPLORER IWebBrowser2, advises both event sinks, **overrides the session user agent** (`UrlMkSetSessionOption(URLMON_OPTION_USERAGENT, "Mozilla/4.0 (compatible; MSIE 7.0) " + FString::ClientExternalBrowserUserAgent)`) so the embedded browser identifies itself with a FastString-configurable suffix, then navigates to the target URL. Close paths (WM_CLOSE, script window.close via DISPID_WINDOWCLOSING) funnel into `WebBrowserEvents::WindowClosing`, which ends the dialog and signals `GuiService::urlWindowClosed` back on the DataModel.

## API

Real signatures / behavior:

- `RbxWebView::RbxWebView(const std::string& url, shared_ptr<Game> newGame)` — m_cRef=1, dialogActive=false.
- `HRESULT RbxWebView::QueryInterface(...)` — opens with `*ppvObject = 0; // this line pleases Raymond Chen`; serves IID_IUnknown and IID_IDispatch only (E_NOINTERFACE otherwise).
- `LRESULT OnInitDialog(UINT, WPARAM, LPARAM, BOOL&)` — CenterWindow; icons; GetDlgControl(IDC_RBXEXPLORER); FindConnectionPoint ×2 + Advise(&webBrowserEvents); UA override as above; `pWebBrowser->Navigate(_bstr_t(url.c()), NULL×4)`; failure ⇒ MessageBox "Failed to open web browser"; sets `dialogActive = true`.
- `LRESULT OnSize(...)` — resizes the control: `put_Width(rect.Width() - SM_CXVSCROLL)`, `put_Height(rect.Height() - SM_CXHSCROLL - SM_CYSIZE)` (note: horizontal scrollbar metric used for height too — verbatim quirk).
- `LRESULT OnClose(...)` / `void closeDialog()` — both just `webBrowserEvents.WindowClosing()` when active.
- `void PostNcDestroy()` — declared; not defined in this file? (defined nowhere here — see gotchas).
- `SHDocVw::IWebBrowserAppPtr getWebBrowser()` — GetDlgControl wrapper.
- IDispatch::Invoke on RbxWebView itself is a no-op S_OK and GetIDsOfNames maps nothing — unlike WebBrowserAxDialog, window.external has no methods here.
- `WebBrowserEvents::Invoke(DISPID, ...)` — only DISPID_WINDOWCLOSING handled → WindowClosing(pDispParams). BeforeNavigate2 identical to WebBrowserAxDialog's: `RBX::Http::trustCheckBrowser(url) ? S_OK : E_FAIL`.
- `static void doSignalGuiServiceUrlWindowClose(DataModel*)` / `signalGuiServiceUrlWindowClosed(DataModel*)` — submit Task that calls `guiService->urlWindowClosed()` under Write job.
- `HRESULT WebBrowserEvents::WindowClosing(DISPPARAMS* pDispParams)` — cancels the MSHTML close (`*(VARIANT_BOOL*)rgvarg[0].byref = VARIANT_TRUE`), `rbxWebView->EndDialog(IDCANCEL)`, setDialogActive(false), signals urlWindowClosed if Game alive, nulls rbxWebView.
- FASTSTRING(ClientExternalBrowserUserAgent) declared here.

## Usage

Flow from Lua: GuiService openUrlWindow signal → Application::openUrlInBrowserApp → this dialog. The urlWindowClosed round-trip is what Application.cpp wires ("needed to clean up window when user closes it").

## Gotchas

- `PostNcDestroy` is declared in the header but has no definition in this .cpp — it is only instantiated if called; UNKNOWN where/whether linked from elsewhere (CAxDialogImpl base provides one; this declaration shadows nothing harmful).
- UA override is session-global (UrlMkSetSessionOption), affecting every URLMON client in the process, not just this control.
- Height uses SM_CXHSCROLL (a width metric) — cosmetic bug preserved verbatim.
- WindowClosing nulls `rbxWebView` but never re-SetRbxWebView's; second close attempt would deref NULL — guarded in practice by dialogActive flag.
