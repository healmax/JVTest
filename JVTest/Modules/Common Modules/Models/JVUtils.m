//
//  JVUtils.m
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/27.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import "JVUtils.h"

@interface JVUtils()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation JVUtils

+ (instancetype)sharedInstance {
    static JVUtils *sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - formmater

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy/MM/dd,HH:mm:ss"];
    }
    return _dateFormatter;
}

#pragma mark - Directory

- (BOOL)fileExistsAtPath:(NSString *)filePath {
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

- (NSString *)cacheDirectory {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
}

@end
