# Android/ifaddrs.h

## Purpose
BSD-licensed shim header providing the classic BSDI `struct ifaddrs` layout plus `getifaddrs`/`freeifaddrs` declarations, for old Android NDKs whose libc lacked them. Vendored third-party code (Berkeley Software Design, 1995/1999), not Roblox-authored.

## API
```c
struct ifaddrs {
    struct ifaddrs  *ifa_next;
    char            *ifa_name;
    unsigned int     ifa_flags;
    struct sockaddr *ifa_addr;
    struct sockaddr *ifa_netmask;
    struct sockaddr *ifa_dstaddr;
    void            *ifa_data;
};
#define ifa_broadaddr ifa_dstaddr   // unless net/if.h already defined it
int  getifaddrs(struct ifaddrs **ifap);
void freeifaddrs(struct ifaddrs *ifa);
```

## Usage
Pairs with rbx/Android/ifaddrs.c, which contains the implementation. Included by Android networking code that enumerates interfaces (IP discovery).

## Gotchas
- Header comment: `<net/if.h>` must be included BEFORE this header or the ifa_broadaddr macro can conflict.
- Modern NDKs ship their own `<ifaddrs.h>` — include-path order decides which wins; duplicate symbol definitions would clash at link time.
