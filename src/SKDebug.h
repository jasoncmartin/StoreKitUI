//
//  SKDebug.h
//  StoreKitUI
//
//  Created by Jason C. Martin on 1/3/10.
//  Copyright 2010 New Media Geekz. All rights reserved.
//

#define SKLOGLEVEL_INFO     5
#define SKLOGLEVEL_WARNING  3
#define SKLOGLEVEL_ERROR    1

#ifndef SKMAXLOGLEVEL
#define SKMAXLOGLEVEL SKLOGLEVEL_WARNING
#endif

#ifdef DEBUG
#define SKDPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __FILE__, __LINE__, ##__VA_ARGS__)
#else
#define SKDPRINT(xx, ...)  ((void)0)
#endif

#define SKDPRINTMETHODNAME() SKDPRINT(@"%@", NSStringFromSelector(_cmd))

#if SKLOGLEVEL_ERROR <= SKMAXLOGLEVEL
#define SKDERROR(xx, ...)  SKDPRINT(xx, ##__VA_ARGS__)
#else
#define SKDERROR(xx, ...)  ((void)0)
#endif

#if SKLOGLEVEL_WARNING <= SKMAXLOGLEVEL
#define SKDWARNING(xx, ...)  SKDPRINT(xx, ##__VA_ARGS__)
#else
#define SKDWARNING(xx, ...)  ((void)0)
#endif

#if SKLOGLEVEL_INFO <= SKMAXLOGLEVEL
#define SKDINFO(xx, ...)  SKDPRINT(xx, ##__VA_ARGS__)
#else
#define SKDINFO(xx, ...)  ((void)0)
#endif

#ifdef DEBUG
#define SKDCONDITIONLOG(condition, xx, ...) { if ((condition)) { \
SKDPRINT(xx, ##__VA_ARGS__); \
} \
} ((void)0)
#else
#define SKDCONDITIONLOG(condition, xx, ...) ((void)0)
#endif
