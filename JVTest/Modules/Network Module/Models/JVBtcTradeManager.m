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

static NSInteger const kMaxHistoryCount = 20;

@interface JVBtcTradeManager()

@property (strong, nonatomic) NSMutableArray<JVPriceInfo *> *binanceHistory;
@property (strong, nonatomic) NSMutableArray<JVPriceInfo *> *bitMexHistory;

//是否已經有單子
@property (assign, nonatomic) BOOL alreadyTransaction;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(binanceSocketManagerDidReceiveMessage:) name:kJVBinanceSocketManagerDidReceiveMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bitMexSocketManagerDidReceiveMessage:) name:kJVBitMexSocketManagerDidReceiveMessage object:nil];
    
    self.binanceHistory = [NSMutableArray new];
    self.bitMexHistory = [NSMutableArray new];
}

- (void)binanceSocketManagerDidReceiveMessage:(NSNotification *)notification {
    JVPriceInfo *priceInfo = notification.object;
    @synchronized(self) {
        if (self.binanceHistory.count >= kMaxHistoryCount) {
            [self.binanceHistory removeObjectAtIndex:0];
        }
        [self.binanceHistory addObject:priceInfo];
    }
    
    [self checkIfNeedTrade];
}

- (void)bitMexSocketManagerDidReceiveMessage:(NSNotification *)notification {
    JVPriceInfo *priceInfo = notification.object;
    @synchronized(self) {
        if (self.bitMexHistory.count >= kMaxHistoryCount) {
            [self.bitMexHistory removeObjectAtIndex:0];
        }
        [self.bitMexHistory addObject:priceInfo];
    }
    
    [self checkIfNeedTrade];
}

- (void)checkIfNeedTrade {
    if (self.alreadyTransaction || self.bitMexHistory.count < kMaxHistoryCount || self.binanceHistory.count < kMaxHistoryCount) {
        return;
    }
    JVPriceInfo *bitMexBtcPriceInfo = [self.bitMexHistory lastObject];
    JVPriceInfo *binanceBtcPriceInfo = [self.binanceHistory lastObject];
    
    NSInteger positiveCount = 0;
    NSInteger negativeCount = 0;
    
    NSMutableArray<NSNumber *> *positiveDiff = [NSMutableArray new];
    NSMutableArray<NSNumber *> *negativeDiff = [NSMutableArray new];
    
    for (int index = 0; index < self.binanceHistory.count - 1; index++) {
        float diffValue = [self.binanceHistory[index+1].price floatValue] - [self.binanceHistory[index].price floatValue];
        if (diffValue > 0) {
            [positiveDiff addObject:@(diffValue)];
            positiveCount++;
        }
        
        if (diffValue < 0) {
            [negativeDiff addObject:@(diffValue)];
            negativeCount++;
        }
    }
    
    //遞增或遞減的數目有超過10筆
    if (positiveCount < kMaxHistoryCount/2 && negativeCount < kMaxHistoryCount/2) {
        return;
    }
    
    if (([binanceBtcPriceInfo.price floatValue] - [bitMexBtcPriceInfo.price floatValue]) > 50) {
        NSLog(@"[Vincent : buy bitMex BTC On %@]", bitMexBtcPriceInfo.price);
    }
    
    if (([binanceBtcPriceInfo.price floatValue] - [bitMexBtcPriceInfo.price floatValue]) < -50) {
        NSLog(@"[Vincent : sell bitMex BTC On %@]", bitMexBtcPriceInfo.price);
    }
}

@end
