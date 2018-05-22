//
//  JVBaseSocketManager.h
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/22.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SRWebSocket.h>

@interface JVBaseSocketManager : NSObject

@property (strong, nonatomic, readonly) SRWebSocket *socket;

- (instancetype)initWithUrl:(NSURL *)url;
- (void)openSocket;
- (void)cancelSocket;

- (void)socketDidOpen;
- (void)subscribeChannelWithString:(NSString *)subscribeString;
- (void)didReceiveMessage:(id)message;

@end
