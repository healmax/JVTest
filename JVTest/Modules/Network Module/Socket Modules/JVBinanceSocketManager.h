//
//  JVBinanceSocketManager.h
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/22.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import "JVBaseSocketManager.h"

extern NSString * const kJVBinanceSocketManagerDidReceiveMessage;

@interface JVBinanceSocketManager : JVBaseSocketManager

+ (instancetype)shareInstance;

@end
