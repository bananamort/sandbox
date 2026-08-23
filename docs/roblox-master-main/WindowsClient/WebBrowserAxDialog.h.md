# WindowsClient/WebBrowserAxDialog.h

## Purpose

Declares the modal IE/Trident ActiveX dialog used for screenshot and video upload flows: `WebBrowserAxDialog` (CAxDialogImpl hosting an IWebBrowser2 control on template IDD_UPLOADVIDEODIALOG, plus IDocHostUIHandler + IDispatch for `window.external` bridging) and `DWebBrowserEventsImpl` (hand-rolled DWebBrowserEvents/DWebBrowserEvents2 sink). The JS page inside calls AppHost* methods; the dialog performs the actual HTTP uploads.

## API

Key declarations:

```cpp
class DWebBrowserEventsImpl : public DWebBrowserEvents {
    // full IUnknown + IDispatch; methods:
    HRESULT BeforeNavigate(...);  HRESULT BeforeNavigate2(...);  HRESULT NavigateComplete(_bstr_t URL);
    WebBrowserAxDialog *m_cpParent;
public: void SetParent(WebBrowserAxDialog*);
};

class WebBrowserAxDialog :
    public CAxDialogImpl<WebBrowserAxDialog>,
    public IDocHostUIHandler,
    public IDispatch {
    ULONG m_cRef; HICON m_hIcon; std::string url;
    boost::shared_ptr<RBX::DataModel> dataModel;
    boost::function<void(bool)> enableUpload;
    void DoPostImage(std::string filename, std::string seostr);
    void UploadVideo(std::string token, SHORT doPost, SHORT postSetting, std::string title);
    void DoUploadVideo(std::string token, std::string title, std::string seostr, int placeId);
    // video state: videoSEOInfo, siteSEO, videoTitle, youtubeToken, fileName
    DWebBrowserEventsImpl m_events;
public:
    enum { IDD = IDD_UPLOADVIDEODIALOG };
    BEGIN_MSG_MAP ... WM_INITDIALOG→OnInitDialog, WM_CLOSE→OnClose ...
    WebBrowserAxDialog(const std::string& url, shared_ptr<DataModel>, boost::function<void(bool)> enableUpload);
    WebBrowserAxDialog(const std::string& url, shared_ptr<DataModel>);           // no callback
    LRESULT OnInitDialog(...); LRESULT OnClose(...);
    void SetFileName(std::string file);
    // IUnknown, IDispatch (GetIDsOfNames maps window.external names), IDocHostUIHandler
};
```

## Usage

Constructed by GameVerbs (askUploadScreenshot / uploadVideo) with a BaseUrl-derived `/UploadMedia/...` URL; also referenced by Document/Application plumbing. See .cpp.md for the external-name contract.

## Gotchas

- Header line 77 contains a real syntax oddity — `STDMETHOD(QueryInterface(REFIID riid, void __RPC_FAR *__RPC_FAR *ppvObject));` (parenthesis inside the macro arg) — compiles only because STDMETHOD expands to `virtual HRESULT STDMETHODCALLTYPE` + the rest; treat exact spelling carefully when diffing.
