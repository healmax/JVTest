//
//  JVBitMexSocketManager.h
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/22.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JVBaseSocketManager.h"

extern NSString * const kJVBitMexSocketManagerDidReceiveMessage;

@interface JVBitMexSocketManager : JVBaseSocketManager

+ (instancetype)shareInstance;

@end
