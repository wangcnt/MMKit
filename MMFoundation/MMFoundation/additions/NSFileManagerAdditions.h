//
//  NSFileManagerAdditions.h
//  IEMAA
//
//  Created by Mr. Wang on 12-10-24.
//
//

#import <Foundation/Foundation.h>

@interface NSFileManager(Additions)

- (BOOL)createFolderAtPathIfNeeds:(NSString *)path;

- (BOOL)writeInfo:(id)info toFileAtPath:(NSString *)path;

- (BOOL)clearAtPath:(NSString *)path;

@end
