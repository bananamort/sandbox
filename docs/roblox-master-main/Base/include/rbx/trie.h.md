# rbx/trie.h

## Purpose
Fixed-depth ASCII trie (`rbx::trie<V, maxDepth>`) with a 96-slot child array per node (chars 32–127), boost::object_pool-backed nodes and values, and a memory-saving "leaf shortcut": branchless subtrees collapse into a `std::string leaf` + single value.

## API
```cpp
template<class V, unsigned int maxDepth> class trie : boost::noncopyable {
    class depth_exceeded_exception : public std::exception;  // "trie depth exceeded"
    class bad_key : public std::exception { const char key; }; // "key out of range"

    trie();                       // root at depth 1
    ~trie();                      // recursive pool destroy
    static bool equal(const char* s, const char* k);   // hand-rolled strcmp (comment: much faster)
    bool lookup(const char* key, V& value) const;      // copies value out on hit
    V& operator[](const char* key);                    // insert-or-access
    size_t compute_size();
    size_t compute_memory_usage();
    template<class F> void each_value(const F& f) const;
};
```

## Usage
Prefix-keyword tables (e.g. script keyword sets) where lookup speed beats memory footprint ("fast but a little expensive memory-wise").

## Gotchas
- In-file: "operator[] is not thread safe" — external locking required for concurrent writes.
- Keys below char 32 throw `bad_key`; chars >127 wrap through `(unsigned char)(c-32)` and index OUT OF the 96-slot array bounds (no upper-bound check in `to_index`) — caller must pre-validate.
- Depth beyond `maxDepth` throws from inside Node construction.
- BUG visible at Node::each_value: the recursive call `each_value(f)` omits `array[i]`, so it recurses on `this` infinitely rather than visiting children — do not use `each_value` until fixed (UNKNOWN whether any caller exists).
