# Darwin/HttpCocoa.h

**Source**: `App/util/Darwin/HttpCocoa.h` (13 lines).

## Purpose
Header included by HttpCocoa.mm to pull in Apple's Foundation/Cocoa frameworks. Contains no declarations of its own.

## API
```objc
#if __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ >= 30000 || __IPHONE_OS_VERSION_MIN_REQUIRED >= 30000
    #import <Foundation/Foundation.h>
#else
    #import <Cocoa/Cocoa.h>
    #import <Foundation/Foundation.h>
#endif
```

## Usage
Sole include of the Mac HTTP implementation (`HttpCocoa.mm`); iOS builds get Foundation only, desktop Mac gets full Cocoa.

## Gotchas
- File is named `HttpCocoa.h` but its top comment says `HttpImpl.h` — renamed artifact.
- No include guard beyond Obj-C import idempotence; relies on `#import`.
