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
#import <CoreGraphics/CoreGraphics.h>

#define __stringify__(KEY)      static NSString const*(KEY) = @#KEY;  ///< __stringify__(ABCDE) -> @"ABCDE"
#define __weakify__(type)       __weak typeof(type) weaked##type = type;  ///< __weakify__(text) -> weakedtext
#define __strongify__(type)     __strong typeof(type) stronged##type = type;  ///< __strongify__(text) -> strongedtext

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

#define __mm_exe_block__(block, BOOL_onMainThread, ...)     \
if(block) {                                                 \
    if(BOOL_onMainThread) {                                 \
        if([NSThread isMainThread]) {                       \
            block(__VA_ARGS__);                             \
        } else {                                            \
            dispatch_async(dispatch_get_main_queue(), ^ {   \
                block(__VA_ARGS__);                         \
            });                                             \
        }                                                   \
    } else {                                                \
        block(__VA_ARGS__);                                 \
    }                                                       \
}

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


/**
 *  Given a scalar or struct value, wraps it in NSValue
 *  Based on EXPObjectify: https://github.com/specta/expecta
 */
static inline id _mm_box_value(const char *type, ...) {
    va_list v;
    va_start(v, type);
    id obj = nil;
    if (strcmp(type, @encode(id)) == 0) {
        id actual = va_arg(v, id);
        obj = actual;
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize)va_arg(v, CGSize);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(double)) == 0) {
        double actual = (double)va_arg(v, double);
        obj = [NSNumber numberWithDouble:actual];
    } else if (strcmp(type, @encode(float)) == 0) {
        float actual = (float)va_arg(v, double);
        obj = [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(int)) == 0) {
        int actual = (int)va_arg(v, int);
        obj = [NSNumber numberWithInt:actual];
    } else if (strcmp(type, @encode(long)) == 0) {
        long actual = (long)va_arg(v, long);
        obj = [NSNumber numberWithLong:actual];
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long actual = (long long)va_arg(v, long long);
        obj = [NSNumber numberWithLongLong:actual];
    } else if (strcmp(type, @encode(short)) == 0) {
        short actual = (short)va_arg(v, int);
        obj = [NSNumber numberWithShort:actual];
    } else if (strcmp(type, @encode(char)) == 0) {
        char actual = (char)va_arg(v, int);
        obj = [NSNumber numberWithChar:actual];
    } else if (strcmp(type, @encode(bool)) == 0) {
        bool actual = (bool)va_arg(v, int);
        obj = [NSNumber numberWithBool:actual];
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char actual = (unsigned char)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedChar:actual];
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int actual = (unsigned int)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedInt:actual];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long actual = (unsigned long)va_arg(v, unsigned long);
        obj = [NSNumber numberWithUnsignedLong:actual];
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long actual = (unsigned long long)va_arg(v, unsigned long long);
        obj = [NSNumber numberWithUnsignedLongLong:actual];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short actual = (unsigned short)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedShort:actual];
    }
    va_end(v);
    return obj;
}

static inline id mm_box_value(value) {
    return _mm_box_value(@encode(__typeof__((value))), (value));
}

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

static inline NSString *mm_int_to_str(NSInteger integer) {
    return [NSString stringWithFormat:@"%ld", integer];
}

static inline NSString *mm_float_to_str(float flt) {
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
