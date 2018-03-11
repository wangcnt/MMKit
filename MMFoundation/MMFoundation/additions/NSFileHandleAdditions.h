//
//  NSFileHandleAdditions.h
//  MMFoundation
//
//  Created by Mark on 2018/3/11.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileHandle (Additions)

- (NSData *)readLineWithDelimiter:(NSString *)theDelimiter; ///< 按分隔符读一段数据，但最后会不愿指针位置

@end
