//
//  JVBinanceApiMAnager.m
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/21.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import "JVBinanceApiManager.h"
#import "JVPriceInfo.h"
#import <AFNetworking/AFNetworking.h>

static NSString * const kBinanceUrlString = @"https://api.binance.com";

@interface JVBinanceApiManager()

@property (strong, nonatomic, readwrite) AFHTTPSessionManager *manager; // compose

@end

@implementation JVBinanceApiManager

+(instancetype)sharedManager
{
    static JVBinanceApiManager *shared = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shared = [[JVBinanceApiManager alloc] init];
    });
    return shared;
}

-(instancetype)init {
    if (self = [super init]) {
        NSURL *url = [NSURL URLWithString:kBinanceUrlString];
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
        serializer.removesKeysWithNullValues = YES;
        self.manager.responseSerializer = serializer;
    }
    
    return self;
}

- (void)getBTCHistoryWithStartTimeTimeStamp:(NSUInteger)startTimeTimeStamp completion:(void(^)(NSArray<JVPriceInfo *> *priceInfos, NSError *error))completion {
    NSString *path = @"api/v1/klines";
    NSDictionary *parameters = @{
                                 @"symbol" : @"BTCUSDT",
                                 @"interval" : @"1m",
                                 @"startTime" : [@(startTimeTimeStamp) stringValue]
                                 };
    [self.manager GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *results = [NSMutableArray new];
        JVPriceInfo *priceInfo;
        for (NSArray *priceInfoArray in responseObject) {
            priceInfo = [[JVPriceInfo alloc] initWithBinanceApiArrayInfo:priceInfoArray];
            [results addObject:priceInfo];
        }
        
        if (completion) {
            completion([results copy], nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

@end
