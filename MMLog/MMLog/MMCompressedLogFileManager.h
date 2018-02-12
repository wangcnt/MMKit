//
//  MMCompressedLogFileManager.h
//  MMLog
//
//  Created by Mark on 2018/2/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaLumberjack.h"

@interface MMCompressedLogFileManager : DDLogFileManagerDefault {
    BOOL upToDate;
    BOOL isCompressing;
}

@end
