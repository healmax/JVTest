//
//  JVBtcHistoryManager.m
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/22.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import "JVBtcTradeManager.h"
#import "JVBinanceSocketManager.h"
#import "JVBitMexSocketManager.h"
#import "JVPriceInfo.h"

@interface JVBtcTradeManager()

@property (strong, nonatomic) NSMutableArray<JVPriceInfo *> *binanceHistory;
@property (strong, nonatomic) NSMutableArray<JVPriceInfo *> *bitMexHistory;

@end

@implementation JVBtcTradeManager

+ (instancetype)shareInstance {
    static JVBtcTradeManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JVBtcTradeManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    
}


@end
