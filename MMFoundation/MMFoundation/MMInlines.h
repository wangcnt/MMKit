//
//  MMInlines.h
//  MMFoundation
//
//  Created by Mark on 2018/4/6.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#ifndef MMInlines_h
#define MMInlines_h

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

static inline NSString *mm_bundle_name() {
    return [NSBundle mainBundle].infoDictionary[@"CFBundleName"];
}

static inline NSString *mm_bundle_version() {
    return [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
}

static inline NSString *mm_build_version() {
    return [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
}

static inline NSString *mm_application_name() {
    NSString *appName = mm_bundle_identifier();
    NSMutableArray *components = [NSMutableArray arrayWithArray:[appName componentsSeparatedByString:@"."]];
    [components filterUsingPredicate:[NSPredicate predicateWithFormat:@"SELF <> ''"]];
    return [components componentsJoinedByString:@"."];
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

static inline float mm_radian_to_degrees(float radian) {
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

#endif /* MMInlines_h */
