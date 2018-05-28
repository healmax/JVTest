//
//  JVUtils.h
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/27.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVUtils : NSObject

+ (instancetype)sharedInstance;

#pragma mark - formmater
- (NSDateFormatter *)dateFormatter;

#pragma mark - Directory
- (BOOL)fileExistsAtPath:(NSString *)filePath;
- (NSString *)cacheDirectory;

@end
