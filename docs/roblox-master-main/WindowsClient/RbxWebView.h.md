# WindowsClient/RbxWebView.h

## Purpose

Declares `RbxWebView` — the modeless in-game web window (template IDD_RBXWEBVIEW) that GuiService-driven URL opens land in (`Application::openUrlInBrowserApp` connects `guiService->openUrlWindow` to a handler that shows this). Sibling of WebBrowserAxDialog but simpler: no upload logic, no external-name dispatch, adds WM_SIZE resizing and a Game weak_ptr so closing can signal `GuiService::urlWindowClosed`.

## API

```cpp
class WebBrowserEvents : public DWebBrowserEvents {
    // IUnknown + IDispatch; BeforeNavigate/BeforeNavigate2;
    HRESULT WindowClosing(DISPPARAMS* pDispParams = NULL);
    RbxWebView *rbxWebView;  void SetRbxWebView(RbxWebView*);
};

class RbxWebView : public CAxDialogImpl<RbxWebView>,
                   public IDocHostUIHandler, public IDispatch {
    ULONG m_cRef; HICON m_hIcon; std::string url;
    weak_ptr<RBX::Game> game;
    bool dialogActive;
    WebBrowserEvents webBrowserEvents;
public:
    enum { IDD = IDD_RBXWEBVIEW };
    BEGIN_MSG_MAP: WM_INITDIALOG→OnInitDialog, WM_CLOSE→OnClose, WM_SIZE→OnSize
    RbxWebView(const std::string& url, shared_ptr<RBX::Game> game);
    weak_ptr<RBX::Game> getGame();
    SHDocVw::IWebBrowserAppPtr RbxWebView::getWebBrowser();   // note redundant qualification
    LRESULT OnInitDialog(...); LRESULT OnClose(...); LRESULT OnSize(...);
    void closeDialog(); void PostNcDestroy(); void setDialogActive(bool);
    // IUnknown / IDispatch / IDocHostUIHandler (same shape as WebBrowserAxDialog)
};
```

## Usage

Shown when game Lua/server triggers an URL open through GuiService; closed via WindowClosing chain that fires `urlWindowClosed`. See .cpp.md.

## Gotchas

- Same header quirk as WebBrowserAxDialog.h (line 77 there): `STDMETHOD(QueryInterface(REFIID riid, ...))` with nested parens — at line 74 of THIS header.
- `SHDocVw::IWebBrowserAppPtr RbxWebView::getWebBrowser();` — member redundantly qualified inside its own class; verbatim.
