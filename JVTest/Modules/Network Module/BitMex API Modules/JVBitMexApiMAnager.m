//
//  JVBitMexApiMAnager.m
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/21.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import "JVBitMexApiMAnager.h"
#import <AFNetworking/AFNetworking.h>

static NSString * const kBitMexUrlString = @"";

@interface JVBitMexApiMAnager()

@property (strong, nonatomic, readwrite) AFURLSessionManager *manager;

@end

@implementation JVBitMexApiMAnager

+(instancetype)sharedManager
{
    static JVBitMexApiMAnager *shared = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shared = [[JVBitMexApiMAnager alloc] init];
    });
    return shared;
}

-(instancetype)init {
    if (self = [super init]) {
//        NSURL *bitMexURL = [NSURL URLWithString:kBitMexUrlString];
//        self.manager = [[AFURLSessionManager alloc] initWithBaseURL:bitMexURL];
//        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
//        serializer.removesKeysWithNullValues = YES;
//        self.manager.responseSerializer = serializer;
//        
//        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        self.manager.requestSerializer.timeoutInterval = 20.0;
//        self.manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    }
    
    return self;
}

@end
