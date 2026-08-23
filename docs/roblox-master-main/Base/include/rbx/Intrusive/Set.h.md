# rbx/Intrusive/Set.h

## Purpose
Constant-time intrusive unordered set (`RBX::Intrusive::Set<Item, Tag>`): nodes embed a `Hook` (doubly-linked with prev + container back-pointer, inheriting singly `next` from `NextRef`) so insert/remove/membership are O(1), allocation-free and nothrow. Items auto-unlink on destruction; copying a hooked item leaves the copy unlinked while the original keeps membership.

## API
```cpp
template<class Item, class Tag = Item> class Set : boost::noncopyable {
    class Hook { void remove() throw(); bool is_linked() const throw(); Set* container(); };
    class Iterator { /* forward_iterator_tag typedefs */ bool empty() const;
                     Item* operator->(); Item& operator*(); Iterator& operator++(); };
    Set(); ~Set();                       // dtor erases all members
    size_t size() const; bool empty() const;
    Iterator erase(Iterator);            // advances first, then unlinks
    bool remove_element(Item& item);     // false if item belongs to another set
    void insert(Item& item);             // silently removes item from any other set first
    Iterator begin()/end();
    typedef Iterator iterator;
    void push_front(Item&);              // boost::intrusive naming alias of insert
    Iterator iterator_to(Item&);
};
```
The `Tag` parameter lets one item live in multiple distinct set types (each tag = separate hook storage).

## Usage
Membership tracking without allocation — job lists, listener sets, reflection child collections.

## Gotchas
- Inserting into set B silently UNLINKS from set A (flagged in-file TODO questioning whether that should be an error).
- No ConstIterator (in-file TODO).
- Iterator invalidation on erase of *other* elements follows raw-pointer semantics: iterators hold `Item*`; erased element's iterator dangles.
- `Hook::remove()` asserts consistency (`prev!=0 || next!=0`) when linked.
