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

#import "MMBlockDefines.h"
#import "MMInlines.h"

#ifndef __stringify__

#define __stringify__(key)      static NSString *const (key) = @#key;  ///< __stringify__(ABCDE) -> @"ABCDE"

#endif

#ifndef __c_stringify__
#define __c_stringify__(key)    static char *const (key) = #key;  ///< __c_stringify__(ABCDE) -> "ABCDE"
#endif

#ifndef __weakify__
#define __weakify__(obj)       __weak typeof(obj) weaked##obj = obj;  ///< __weakify__(text) -> weakedtext
#endif

#ifndef __strongify__
#define __strongify__(obj)     __strong typeof(obj) stronged##obj = obj;  ///< __strongify__(text) -> strongedtext
#endif

#ifndef __swap__ // swap two value
#define __swap__(a, b)  do { __typeof__(a) _tmp_ = (a); (a) = (b); (b) = _tmp_; } while (0)
#endif

//#ifndef weakify
//    #if DEBUG
//        #if __has_feature(objc_arc)
//            #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
//        #else
//            #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
//        #endif
//    #else
//        #if __has_feature(objc_arc)
//            #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
//        #else
//            #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
//        #endif
//    #endif
//#endif
//
//#ifndef strongify
//    #if DEBUG
//        #if __has_feature(objc_arc)
//            #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
//        #else
//            #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
//        #endif
//    #else
//        #if __has_feature(objc_arc)
//            #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
//        #else
//            #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
//        #endif
//    #endif
//#endif

// Must 3 parameters at least, nil should be appended after BOOL_onMainThread if needs.
#define __mm_exe_block__(block, BOOL_onMainThread, ...) \
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

// Must 3 parameters at least, nil should be appended after dispatch_queue if needs.
#define __mm_dispatch_async__(block, dispatch_queue, ...)   \
if(block && dispatch_queue) {                               \
    dispatch_async(dispatch_queue, ^ {                      \
        block(__VA_ARGS__);                                 \
    });                                                     \
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


#define __proxy_singleton__(CLASS_NAME)                     \
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
- (instancetype)copy {                                      \
    return self;                                            \
}                                                           \
                                                            \
- (instancetype)mutableCopy {                               \
    return self;                                            \
}                                                           \

/**
 Add this macro before each category implementation, so we don't have to use
 -all_load or -force_load to load object files from static libraries that only
 contain categories and no classes.
 More info: http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html .
 *******************************************************************************
 Example:
 __mm_synth_dummy_class__(NSStringAddtions)
 */
#ifndef __mm_synth_dummy_class__
#define __mm_synth_dummy_class__(_name_) \
@interface MMSYNTH_DUMMY_CLASS_##_name_ : NSObject @end \
@implementation MMSYNTH_DUMMY_CLASS_##_name_ @end
#endif


#endif /////// *MMDefines_h */
