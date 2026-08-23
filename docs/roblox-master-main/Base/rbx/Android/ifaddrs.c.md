# Android/ifaddrs.c

## Purpose
Vendored implementation (Kenneth MacKay, 2013, BSD license) of `getifaddrs`/`freeifaddrs` for Android, built on a NETLINK_ROUTE socket: RTM_GETLINK enumerates interfaces (name/MAC/stats), RTM_GETADDR enumerates addresses, and the two are joined by interface index into the classic `struct ifaddrs` list.

## API
Public:
```c
int  getifaddrs(struct ifaddrs **ifap);   // 0 on success; fills linked list
void freeifaddrs(struct ifaddrs *ifa);    // frees list nodes
```
Internal statics: netlink_socket/netlink_send/netlink_recv (EINTR-retrying recv with MSG_TRUNC detection), getNetlinkResponse (starts at 4096 bytes, doubles on truncation), getResultList/newListItem/freeResultList (owns nlmsghdr buffers), calcAddrLen/makeSockaddr (AF_INET/AF_INET6/AF_PACKET sizing+filling), interpretLink/interpretAddr/interpretLinks/interpretAddrs, findInterface (index→link lookup via int stashed after each node).

## Usage
Pairs with include/rbx/Android/ifaddrs.h. Compiled only for Android. Consumers walk `ifa_next`, reading `ifa_addr` (IPv4/IPv6/MAC) for local-IP discovery.

## Gotchas
- interpretLink size accounting bug: `l_nameSize += NLMSG_ALIGN(l_rtaSize + 1)` uses l_rtaSize (remaining attribute-bytes) not l_rtaDataSize — over-allocates, harmless but wrong.
- interpretAddr's first switch case FALLS THROUGH from IFA_ADDRESS/IFA_LOCAL into IFA_BROADCAST, double-counting address space when netmask room was added (again over-allocation, benign).
- Netmask is synthesized from ifa_prefixlen into a 16-byte mask buffer sized by `l_maxPrefix/8` — correct for v4(4B)/v6(16B).
- Nodes are single mallocs (struct + payload tail); freeifaddrs frees nodes only — matches how interpret* allocate (no per-field frees needed).
- nlmsg_seq == socket fd and nlmsg_pid == getpid() used as request correlation; responses from other processes are skipped.
