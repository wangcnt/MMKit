//
//  NSFileManagerAdditions.m
//  IEMAA
//
//  Created by Mr. Wang on 12-10-24.
//
//

#import "NSFileManagerAdditions.h"

#import "MMDefines.h"

__mm_synth_dummy_class__(NSFileManagerAdditions)

@implementation NSFileManager(Additions)

- (BOOL)createFolderAtPathIfNeeds:(NSString *)path {
    BOOL isDirectory;
    BOOL exists = [self fileExistsAtPath:path isDirectory:&isDirectory];
    if(exists && isDirectory) {
        return YES;
    }
    NSError *error;
    if([self createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]
       && !error) {
        return YES;
    }
    return NO;
}

- (BOOL)clearAtPath:(NSString *)path {
    BOOL successed = YES;
    BOOL isDirectory;
    if([self fileExistsAtPath:path isDirectory:&isDirectory]) {
        if(isDirectory)  {
            NSArray *subfiles = [self contentsOfDirectoryAtPath:path error:nil];
            for(NSString *fileName in subfiles) {
                [self clearAtPath:[path stringByAppendingPathComponent:fileName]];
            }
        }
        [self removeItemAtPath:path error:nil];
    }
    return successed;
}

- (BOOL)writeInfo:(id)info toFileAtPath:(NSString *)path {
    NSError *error = nil;
    BOOL flag = NO;
    if([info isKindOfClass:[NSString class]]) {
        flag = [info writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    } else if([info isKindOfClass:[NSArray class]]
            || [info isKindOfClass:[NSDictionary class]]) {
        flag = [info writeToFile:path atomically:YES];
    }
    NSLog(@"create-file[%@]-flag[%d]-error[%@]", path, flag, error.localizedDescription);
    return (flag && !error);
}

- (BOOL)addSkipBackupAttributeToFile:(NSString *)path {
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    NSError *error;
    return [url setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:&error] && !error;
}

@end
