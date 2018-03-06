//
//  MMDefines.h
//  MMFoundation
//
//  Created by Mark on 2018/2/10.
//  Copyright © 2018年 Mark. All rights reserved.
//

#ifndef MMDefines_h
#define MMDefines_h

#import <Foundation/Foundation.h>

#define define_string(KEY) static NSString const*(KEY) = @#KEY;  /// define_string(ABCDE)

static inline NSString *mm_document_path() {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
}

static inline NSString *mm_temporary_path() {
    return NSTemporaryDirectory();
}

static inline NSString *mm_caches_path() {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
}

static inline NSString *mm_library_path() {
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
}

static inline NSString *mm_application_name() {
    NSString *appName = [NSBundle mainBundle].bundleIdentifier;
    NSMutableArray *components = [NSMutableArray arrayWithArray:[appName componentsSeparatedByString:@"."]];
    [components filterUsingPredicate:[NSPredicate predicateWithFormat:@"SELF <> ''"]];
    return [components componentsJoinedByString:@"."];
}

static inline NSString *mm_bundle_version() {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
}

static inline NSInteger mm_bound_integer(NSInteger value, NSInteger min, NSInteger max) {
    if (max < min) {
        max = min;
    }
    NSInteger bounded = value;
    if (bounded > max) {
        bounded = max;
    }
    if (bounded < min) {
        bounded = min;
    }
    return bounded;
}

static inline float mm_bound_float(float value, float min, float max) {
    if (max < min) {
        max = min;
    }
    float bounded = value;
    if (bounded > max) {
        bounded = max;
    }
    if (bounded < min) {
        bounded = min;
    }
    return bounded;
}

static inline float mm_floor_float(float x) {
#if float_IS_DOUBLE
    return floor(x);
#else
    return floorf(x);
#endif
}

static inline float mm_abs_float(float x) {
#if float_IS_DOUBLE
    return fabs(x);
#else
    return fabsf(x);
#endif
}

static inline float mm_ceil_float(float x) {
#if float_IS_DOUBLE
    return ceil(x);
#else
    return ceilf(x);
#endif
}

static inline float mm_round_float(float x) {
#if float_IS_DOUBLE
    return round(x);
#else
    return roundf(x);
#endif
}

static inline float mm_sqrt_float(float x) {
#if float_IS_DOUBLE
    return sqrt(x);
#else
    return sqrtf(x);
#endif
}

static inline float mm_copysign_float(float x, float y) {
#if float_IS_DOUBLE
    return copysign(x, y);
#else
    return copysignf(x, y);
#endif
}

static inline float mm_pow_float(float x, float y) {
#if float_IS_DOUBLE
    return pow(x, y);
#else
    return powf(x, y);
#endif
}

static inline float mm_cos_float(float x) {
#if float_IS_DOUBLE
    return cos(x);
#else
    return cosf(x);
#endif
}

#endif /////// *MMDefines_h */
