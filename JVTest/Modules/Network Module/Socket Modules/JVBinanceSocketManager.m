//
//  JVBinanceSocketManager.m
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/22.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import "JVBinanceSocketManager.h"
#import "JVPriceInfo.h"

static NSString * const kBinanceSocketUrl = @"wss://stream.binance.com:9443/ws/btcusdt@ticker";
NSString * const kJVBinanceSocketManagerDidReceiveMessage = @"JVBinanceSocketManagerDidReceiveMessage";

@implementation JVBinanceSocketManager

+ (instancetype)shareInstance {
    static JVBinanceSocketManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:kBinanceSocketUrl];
        manager = [[JVBinanceSocketManager alloc] initWithUrl:url];
    });
    
    return manager;
}

- (void)didReceiveMessage:(NSDictionary *)message {
    JVPriceInfo *priceInfo = [[JVPriceInfo alloc] initWithBinanceSocketJSON:message];
    [[NSNotificationCenter defaultCenter] postNotificationName:kJVBinanceSocketManagerDidReceiveMessage object:priceInfo];
}

@end
