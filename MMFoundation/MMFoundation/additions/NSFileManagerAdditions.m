//
//  NSFileManagerAdditions.m
//  IEMAA
//
//  Created by Mr. Wang on 12-10-24.
//
//

#import "NSFileManagerAdditions.h"

@implementation NSFileManager(Additions)

- (BOOL)createFolderAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        if([fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
            if(error!=nil) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)clear:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL successed = YES;
    BOOL isDirectory;
    if([fileManager fileExistsAtPath:path isDirectory:&isDirectory]) {
        //如果是目录，递归删除子文件
        if(isDirectory)  {
            NSArray *subfiles = [fileManager contentsOfDirectoryAtPath:path error:nil];
            for(NSString *fileName in subfiles) {
                [fileManager clear:[path stringByAppendingPathComponent:fileName]];
            }
        }
        [fileManager removeItemAtPath:path error:nil];
    }
    return successed;
}

- (BOOL)writeInfo:(id)info toFileAtPath:(NSString *)path {
    NSError *error = nil;
    BOOL flag = NO;
    if([info isKindOfClass:[NSString class]]) {
        flag = [info writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    } else if(    [info isKindOfClass:[NSArray class]]
            ||  [info isKindOfClass:[NSDictionary class]]) {
        flag = [info writeToFile:path atomically:YES];
    }
    NSLog(@"create-file[%@]-flag[%d]-error[%@]", path, flag, error.localizedDescription);
    return (flag && !error);
}

@end
