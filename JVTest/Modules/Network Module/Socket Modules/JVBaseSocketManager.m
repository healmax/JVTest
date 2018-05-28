//
//  JVBaseSocketManager.m
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/22.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import "JVBaseSocketManager.h"
#import <SocketRocket/SRWebSocket.h>
#import <BlocksKit/BlocksKit.h>

static NSTimeInterval kCheckingTimeInterval = 5.0;

@interface JVBaseSocketManager()<SRWebSocketDelegate>
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic, readwrite) SRWebSocket *socket;
@property (strong, nonatomic) NSDate *lastReceivedDataDate;
@property (strong, nonatomic) NSTimer *checkingTimer;
@end

@implementation JVBaseSocketManager

- (instancetype)initWithUrl:(NSURL *)url {
    if (self = [super init]) {
        _url = url;
        [self setupSocket];
    }
    
    return  self;
}

#pragma mark - public

- (void)setupSocket {
    self.socket = [[SRWebSocket alloc] initWithURL:self.url];
    self.socket.delegate = self;
}

- (void)openSocket {
    [self.socket open];
}

- (void)cancelSocket {
    self.socket.delegate = nil;
    [self.socket close];
    self.socket = nil;
}

- (void)reconnectSocket {
    [self cancelSocket];
    [self setupSocket];
    [self openSocket];
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

#pragma mark - Timer

- (void)setupCheckingTimer {
    __weak typeof(self) weakSelf = self;
    self.checkingTimer = [NSTimer bk_scheduledTimerWithTimeInterval:kCheckingTimeInterval block:^(NSTimer *timer) {
        if ([weakSelf.lastReceivedDataDate timeIntervalSinceNow] + kCheckingTimeInterval < 0) {
            [weakSelf reconnectSocket];
        }
    } repeats:YES];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"web socket did open:%@", self.url);
    [self setupCheckingTimer];
    [self socketDidOpen];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    if (self.socket.readyState != SR_OPEN) {
        return;
    }
    
    if ([message isKindOfClass:[NSString class]]) {
        NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([json isKindOfClass:[NSDictionary class]]) {
            [self didReceiveMessage:json];
            self.lastReceivedDataDate = [NSDate date];
        }
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"web socket:%@ fail with error:%@", self.url, error);
    [self cancelSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"web socket:%@ close with reason:%@", self.url, reason);
    [self reconnectSocket];
}

@end
