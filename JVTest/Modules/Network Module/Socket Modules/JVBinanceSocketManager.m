//
//  JVBinanceSocketManager.m
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/22.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import "JVBinanceSocketManager.h"

static NSString * const kBinanceSocketUrl = @"wss://stream.binance.com:9443/ws/btcusdt@ticker";

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
    
    NSLog(@"%@", message);
}

@end
