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

#define define_string(KEY)      static NSString const*(KEY) = @#KEY;  /// define_string(ABCDE)
#define __weakify__(type)       __weak typeof(type) weak##type = type;
#define __strongify__(type)     __strong typeof(type) stronged##type = type;

#define __singleton__(CLASS_NAME)                           \
static CLASS_NAME *instance = nil;                          \
+ (instancetype)sharedInstance {                            \
    static dispatch_once_t token;                           \
    dispatch_once(&token, ^{                                \
        if(instance == nil) {                               \
            instance = [[CLASS_NAME alloc] init];           \
        }                                                   \
    });                                                     \
    return instance;                                        \
}                                                           \
                                                            \
+ (instancetype)allocWithZone:(struct _NSZone *)zone {      \
    static dispatch_once_t token;                           \
    dispatch_once(&token, ^{                                \
        if(instance == nil) {                               \
            instance = [super allocWithZone:zone];          \
        }                                                   \
    });                                                     \
    return instance;                                        \
}                                                           \
                                                            \
- (instancetype)copy {                                      \
    return self;                                            \
}                                                           \
                                                            \
- (instancetype)mutableCopy {                               \
    return self;                                            \
}                                                           \


#ifdef DEBUG
#define NSLog(...) NSLog(@"%@", __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define NSLog(...)
#endif


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

static inline NSUserDefaults *mm_user_defaults() {
    return [NSUserDefaults standardUserDefaults];
}

static inline NSString *mm_current_language() {
    return [NSLocale preferredLanguages].firstObject;
}

static inline NSString *mm_bundle_identifier() {
    return [NSBundle mainBundle].bundleIdentifier;
}

static inline NSString *mm_application_name() {
    NSString *appName = mm_bundle_identifier();
    NSMutableArray *components = [NSMutableArray arrayWithArray:[appName componentsSeparatedByString:@"."]];
    [components filterUsingPredicate:[NSPredicate predicateWithFormat:@"SELF <> ''"]];
    return [components componentsJoinedByString:@"."];
}

static inline NSString *mm_bundle_version() {
    return [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
}

static inline NSString *mm_str_int(NSInteger integer) {
    return [NSString stringWithFormat:@"%ld", integer];
}

static inline NSString *mm_str_float(float flt) {
    return [NSString stringWithFormat:@"%f", flt];
}

static inline float mm_degrees_to_radian(float degrees) {
    return M_PI * degrees / 180.0;
}

static inline float mm_radian_to_drgrees(float radian) {
    return radian * 180.0 / M_PI;
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
