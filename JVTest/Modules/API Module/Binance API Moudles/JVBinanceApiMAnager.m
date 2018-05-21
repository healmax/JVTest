//
//  JVBinanceApiMAnager.m
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/21.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import "JVBinanceApiMAnager.h"
#import "JVPriceInfo.h"
#import <AFNetworking/AFNetworking.h>

static NSString * const kBinanceUrlString = @"https://api.binance.com";

@interface JVBinanceApiMAnager()

@property (strong, nonatomic, readwrite) AFHTTPSessionManager *manager; // compose

@end

@implementation JVBinanceApiMAnager

+(instancetype)sharedManager
{
    static JVBinanceApiMAnager *shared = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shared = [[JVBinanceApiMAnager alloc] init];
    });
    return shared;
}

-(instancetype)init {
    if (self = [super init]) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
        serializer.removesKeysWithNullValues = YES;
        self.manager.responseSerializer = serializer;
    }
    
    return self;
}

- (void)getBTCPriceWithCompletion:(void(^)(JVPriceInfo *priceInfo, NSError *error))completion {
    

    NSString *path = @"https://api.binance.com/api/v3/ticker/price";
    NSDictionary *parameters = @{
                                 @"symbol" : @"BTCUSDT",
                                 };
    [self.manager GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        JVPriceInfo *priceInfo = [[JVPriceInfo alloc] initWithBinanceJSON:responseObject];
        if (completion) {
            completion(priceInfo, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {

        }
    }];
}

@end
