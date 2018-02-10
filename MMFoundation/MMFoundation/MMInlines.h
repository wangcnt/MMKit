//
//  MMInlines.h
//  MMFoundation
//
//  Created by WangQiang on 2018/2/10.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#ifndef MMInlines_h
#define MMInlines_h

#import <Foundation/Foundation.h>

static inline NSString* mm_document_path() {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
}

static inline NSString* mm_temporary_path() {
    return NSTemporaryDirectory();
}

static inline NSString* mm_caches_path() {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
}

static inline NSString* mm_library_path() {
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
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

#endif /* MMInlines_h */
