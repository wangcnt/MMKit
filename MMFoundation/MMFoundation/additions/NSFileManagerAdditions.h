//
//  NSFileManagerAdditions.h
//  IEMAA
//
//  Created by Mr. Wang on 12-10-24.
//
//

#import <Foundation/Foundation.h>

@interface NSFileManager(Additions)

- (BOOL)createFolderAtPath:(NSString *)path;

- (BOOL)writeInfo:(id)info toFileAtPath:(NSString *)path;

- (BOOL)clear:(NSString *)path;

@end
