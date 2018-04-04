//
//  NSFileHandleAdditions.m
//  MMFoundation
//
//  Created by Mark on 2018/3/11.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import "NSFileHandleAdditions.h"

#import "MMDefines.h"

__mm_synth_dummy_class__(NSFileHandleAdditions)

@implementation NSFileHandle (Additions)

- (NSData *)readLineWithDelimiter:(NSString *)theDelimiter
{
    NSUInteger bufferSize = 1024; // Set our buffer size
    
    // Read the delimiter string into a C string
    NSData *delimiterData = [theDelimiter dataUsingEncoding:NSASCIIStringEncoding];
    const char *delimiter = [delimiterData bytes];
    
    NSUInteger delimiterIndex = 0;
    
    NSData *lineData; // Our buffer of data
    
    unsigned long long currentPosition = [self offsetInFile];
    NSUInteger positionOffset = 0;
    
    BOOL hasData = YES;
    BOOL lineBreakFound = NO;
    
    while (lineBreakFound == NO && hasData == YES)
    {
        // Fill our buffer with data
        lineData = [self readDataOfLength:bufferSize];
        
        // If our buffer gets some data, proceed
        if ([lineData length] > 0)
        {
            // Get a pointer to our buffer's raw data
            const char *buffer = [lineData bytes];
            
            // Loop over the raw data, byte-by-byte
            for (int i = 0; i < [lineData length]; i++)
            {
                // If the current character matches a character in the delimiter sequence...
                if (buffer[i] == delimiter[delimiterIndex])
                {
                    delimiterIndex++; // Move to the next char of the delimiter sequence
                    
                    if (delimiterIndex >= [delimiterData length])
                    {
                        // If we've found all of the delimiter characters, break out of the loop
                        lineBreakFound = YES;
                        positionOffset += i + 1;
                        break;
                    }
                }
                else
                {
                    // Otherwise, reset the current delimiter character offset
                    delimiterIndex = 0;
                }
            }
            
            if (lineBreakFound == NO)
            {
                positionOffset += [lineData length];
            }
        }
        else
        {
            hasData = NO;
            break;
        }
    }
    
    // Use positionOffset to determine the string to return...
    
    // Return to the start of this line
    [self seekToFileOffset:currentPosition];
    
    NSData *returnData = [self readDataOfLength:positionOffset];
    return returnData.length ? returnData : nil;
}

@end
