//
//  JVBitMexSocketManager.m
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/22.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import "JVBitMexSocketManager.h"
#import <SocketRocket/SRWebSocket.h>

static NSString * const kBitMexSocketUrl = @"wss://www.bitmex.com/realtime";

@interface JVBitMexSocketManager()

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
    NSString *subscribeChannel = @"{\"op\": \"subscribe\", \"args\": [\"instrument:XBTUSD\"]}";
    [self subscribeChannelWithString:subscribeChannel];
}

- (void)didReceiveMessage:(id)message {
    NSLog(@"%@", message);
}

@end
