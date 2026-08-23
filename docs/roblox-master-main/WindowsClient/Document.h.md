# WindowsClient/Document.h

## Purpose

Header for `RBX::Document` — "the class responsible for the game state". Owns the `RBX::Game` (a `SecurePlayerGame`), executes the fetched join script/protocol payload on the DataModel thread, and exposes the `startedSignal` used by Application for analytics. Sits between Application (orchestration) and the engine's Game/DataModel.

## API

```cpp
class Document {
public:
    rbx::signal<void(bool)> startedSignal;   // fired with isTeleport
    Document();
    ~Document();
    void Initialize(HWND hWnd, bool useChat);
    void Start(HttpFuture& scriptResult, const SharedLauncher::LaunchMode launchMode,
               bool isTelport, const char* vrDevice);   // note misspelled param 'isTelport'
    void Shutdown();
    void SetUiMessage(const std::string& message);
    void PrepareShutdown();                  // call before destroying the view
    FunctionMarshaller* GetMarshaller() const;
    std::string GetSEOStr() const;
    boost::shared_ptr<Game> getGame() { return game; }
private:
    FunctionMarshaller* marshaller;
    boost::shared_ptr<Game> game;            // SecurePlayerGame
    void executeScript(HttpFuture& scriptResult, const SharedLauncher::LaunchMode launchMode,
                       const char* vrDevice) const;
    void configureDataModelServices(bool useChat, RBX::DataModel* dataModel);
    void dataModelDidRestart();              // declared, never defined/called (UNKNOWN/dead)
    void dataModelWillShutdown();            // declared, never defined/called (UNKNOWN/dead)
    void gameIsLoaded();
};
```

## Usage

Constructed by Application::StartNewGame/InitializeNewGame; `Initialize` is called synchronously, `Start` is submitted as a DataModel Write task once the join-script HTTP future exists.

## Gotchas

- The header declares `dataModelDidRestart()` / `dataModelWillShutdown()` but neither appears in Document.cpp — dead declarations.
- `GetMarshaller()` returns the per-thread FunctionMarshaller captured at Initialize; used by GameVerbs to marshal onto the UI thread.
