//
//  JVBaseSocketManager.m
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/22.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import "JVBaseSocketManager.h"
#import <SocketRocket/SRWebSocket.h>

@interface JVBaseSocketManager()<SRWebSocketDelegate>

@property(strong, nonatomic, readwrite) SRWebSocket *socket;

@end

@implementation JVBaseSocketManager

- (instancetype)initWithUrl:(NSURL *)url {
    if (self = [super init]) {
        self.socket = [[SRWebSocket alloc] initWithURL:url];
        self.socket.delegate = self;
    }
    
    return  self;
}

#pragma mark - public

- (void)openSocket {
    [self.socket open];
}

- (void)cancelSocket {
    [self.socket close];
}

- (void)subscribeChannelWithString:(NSString *)subscribeString {
    if (self.socket.readyState == SR_OPEN) {
        [self.socket send:subscribeString];
    }
    
    return;
}

- (void)socketDidOpen {
    //do nothing
}

- (void)didReceiveMessage:(NSDictionary *)message {
    //do nothing
}

#pragma mark - SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    if ([message isKindOfClass:[NSString class]]) {
        NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([json isKindOfClass:[NSDictionary class]]) {
            [self didReceiveMessage:json];
        }
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    [self socketDidOpen];
}


@end
