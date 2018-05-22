//
//  JVBitMexSocketManager.m
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/22.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import "JVBitMexSocketManager.h"
#import "JVPriceInfo.h"
#import <SocketRocket/SRWebSocket.h>

static NSString * const kBitMexSocketUrl = @"wss://www.bitmex.com/realtime";

NSString * const kJVBitMexSocketManagerDidReceiveMessage = @"JVBitMexSocketManagerDidReceiveMessage";

@interface JVBitMexSocketManager()

@property (copy, nonatomic) void (^subscribeBTCChannelBlock)(void);

@end

@implementation JVBitMexSocketManager

+ (instancetype)shareInstance {
    static JVBitMexSocketManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:kBitMexSocketUrl];
        manager = [[JVBitMexSocketManager alloc] initWithUrl:url];
    });
    
    return manager;
}

- (void)socketDidOpen {
    if (self.subscribeBTCChannelBlock) {
        self.subscribeBTCChannelBlock();
    }
}

- (void)subscribeBTCChannel {
    __weak JVBitMexSocketManager *weakSelf = self;
    self.subscribeBTCChannelBlock = ^{
        NSString *subscribeChannel = @"{\"op\": \"subscribe\", \"args\": [\"instrument:XBTUSD\"]}";
        [weakSelf subscribeChannelWithString:subscribeChannel];
    };
}

- (void)didReceiveMessage:(NSDictionary *)message {
    NSNumber *price = [message[@"data"] firstObject][@"lastPrice"];
    NSString *action = action = message[@"action"];
    
    if (price == nil || ![action isEqualToString:@"update"]) {
        return;
    }
    
    JVPriceInfo *priceinfo = [[JVPriceInfo alloc] initWithBitMexJSON:message];
    [[NSNotificationCenter defaultCenter] postNotificationName:kJVBitMexSocketManagerDidReceiveMessage object:priceinfo];
}

@end
