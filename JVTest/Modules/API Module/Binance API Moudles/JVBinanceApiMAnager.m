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

@property (strong,nonatomic, readwrite) AFHTTPRequestOperationManager *manager; // compose

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
        NSURL *bitMexURL = [NSURL URLWithString:kBinanceUrlString];
        self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:bitMexURL];
        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
        serializer.removesKeysWithNullValues = YES;
        self.manager.responseSerializer = serializer;
        
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.manager.requestSerializer.timeoutInterval = 20.0;
        self.manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    }
    
    return self;
}

- (void)getBTCPriceWithCompletion:(void(^)(JVPriceInfo *priceInfo, NSError *error))completion {
    NSString *path = @"api/v3/ticker/price";
    NSDictionary *parameters = @{
                                 @"symbol" : @"BTCUSDT",
                                 };
    [self.manager GET:path parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        JVPriceInfo *priceInfo = [[JVPriceInfo alloc] initWithBinanceJSON:responseObject];
        if (completion) {
            completion(priceInfo, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (completion) {
            
        }
    }];
}

@end
