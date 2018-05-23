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

static NSInteger const kMaxHistoryCount = 60;

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
    
    static NSInteger count30 = 0;
    static NSInteger count35 = 0;
    static NSInteger count40 = 0;
    static NSInteger count45 = 0;
    static NSInteger count50 = 0;
    
    if (([binanceBtcPriceInfo.price floatValue] - [bitMexBtcPriceInfo.price floatValue]) > 50) {
        count50++;
        NSLog(@"[Vincent : binance price - bitMex price > 50] \"binance price : %@\", \"bitMex price : %@\", \"count : %@\"", binanceBtcPriceInfo.price, bitMexBtcPriceInfo.price, @(count50));
    } else if (([binanceBtcPriceInfo.price floatValue] - [bitMexBtcPriceInfo.price floatValue]) > 45) {
        count45++;
        NSLog(@"[Vincent : binance price - bitMex price > 45] \"binance price : %@\", \"bitMex price : %@\", \"count : %@\"", binanceBtcPriceInfo.price, bitMexBtcPriceInfo.price, @(count45));
    } else if (([binanceBtcPriceInfo.price floatValue] - [bitMexBtcPriceInfo.price floatValue]) > 40) {
        count40++;
        NSLog(@"[Vincent : binance price - bitMex price > 40] \"binance price : %@\", \"bitMex price : %@\", \"count : %@\"", binanceBtcPriceInfo.price, bitMexBtcPriceInfo.price, @(count40));
    } else if (([binanceBtcPriceInfo.price floatValue] - [bitMexBtcPriceInfo.price floatValue]) > 35) {
        count35++;
        NSLog(@"[Vincent : binance price - bitMex price > 35] \"binance price : %@\", \"bitMex price : %@\", \"count : %@\"", binanceBtcPriceInfo.price, bitMexBtcPriceInfo.price, @(count35));
    } else if (([binanceBtcPriceInfo.price floatValue] - [bitMexBtcPriceInfo.price floatValue]) > 30) {
        count30++;
        NSLog(@"[Vincent : binance price - bitMex price > 30] \"binance price : %@\", \"bitMex price : %@\", \"count : %@\"", binanceBtcPriceInfo.price, bitMexBtcPriceInfo.price, @(count30));
    }
    
    
    if (([binanceBtcPriceInfo.price floatValue] - [bitMexBtcPriceInfo.price floatValue]) < -50) {
        count50++;
        NSLog(@"[Vincent : binance price - bitMex price < -50] \"binance price : %@\", \"bitMex price : %@\", \"count : %@\"", binanceBtcPriceInfo.price, bitMexBtcPriceInfo.price, @(count50));
    } else if (([binanceBtcPriceInfo.price floatValue] - [bitMexBtcPriceInfo.price floatValue]) < -45) {
        count45++;
        NSLog(@"[Vincent : binance price - bitMex price < -45] \"binance price : %@\", \"bitMex price : %@\", \"count : %@\"", binanceBtcPriceInfo.price, bitMexBtcPriceInfo.price, @(count45));
    } else if (([binanceBtcPriceInfo.price floatValue] - [bitMexBtcPriceInfo.price floatValue]) < -40) {
        count40++;
        NSLog(@"[Vincent : binance price - bitMex price < -40] \"binance price : %@\", \"bitMex price : %@\", \"count : %@\"", binanceBtcPriceInfo.price, bitMexBtcPriceInfo.price, @(count40));
    } else if (([binanceBtcPriceInfo.price floatValue] - [bitMexBtcPriceInfo.price floatValue]) < -35) {
        count35++;
        NSLog(@"[Vincent : binance price - bitMex price < -35] \"binance price : %@\", \"bitMex price : %@\", \"count : %@\"", binanceBtcPriceInfo.price, bitMexBtcPriceInfo.price, @(count35));
    } else if (([binanceBtcPriceInfo.price floatValue] - [bitMexBtcPriceInfo.price floatValue]) < -30) {
        count30++;
        NSLog(@"[Vincent : binance price - bitMex price < -30] \"binance price : %@\", \"bitMex price : %@\", \"count : %@\"", binanceBtcPriceInfo.price, bitMexBtcPriceInfo.price, @(count30));
    }
    
    NSInteger positiveCount = 0;
    NSInteger negativeCount = 0;
    
    NSMutableArray<NSNumber *> *positiveDiff = [NSMutableArray new];
    NSMutableArray<NSNumber *> *negativeDiff = [NSMutableArray new];
    
    float quantity = 0;
    NSInteger inRangeCount = 0;
    
    for (int index = 0; index < self.binanceHistory.count - 1; index++) {
        JVPriceInfo *firstInfo = self.binanceHistory[index];
        BOOL isInRange = ((binanceBtcPriceInfo.timeStamp - firstInfo.timeStamp) / 1000) < 30 ? YES : NO;
        if (!isInRange) {
            continue;
        }
        inRangeCount++;
        quantity += [firstInfo.quantity floatValue];
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
    if (positiveCount < inRangeCount/2 && negativeCount < inRangeCount/2) {
        return;
    }
    
    if (quantity < 30) {
        return;
    }
    
    if (([binanceBtcPriceInfo.price floatValue] - [bitMexBtcPriceInfo.price floatValue]) > 50) {
        NSLog(@"[Vincent : diff > 50 buy bitMex BTC On %@]", bitMexBtcPriceInfo.price);
    } else if (([binanceBtcPriceInfo.price floatValue] - [bitMexBtcPriceInfo.price floatValue]) > 45) {
        NSLog(@"[Vincent : diff > 45 buy bitMex BTC On %@]", bitMexBtcPriceInfo.price);
    } else if (([binanceBtcPriceInfo.price floatValue] - [bitMexBtcPriceInfo.price floatValue]) > 40) {
        NSLog(@"[Vincent : diff > 40 buy bitMex BTC On %@]", bitMexBtcPriceInfo.price);
    } else if (([binanceBtcPriceInfo.price floatValue] - [bitMexBtcPriceInfo.price floatValue]) > 35) {
        NSLog(@"[Vincent : diff > 35 buy bitMex BTC On %@]", bitMexBtcPriceInfo.price);
    } else if (([binanceBtcPriceInfo.price floatValue] - [bitMexBtcPriceInfo.price floatValue]) > 30) {
        NSLog(@"[Vincent : diff > 30 buy bitMex BTC On %@]", bitMexBtcPriceInfo.price);
    }
    
    if (([binanceBtcPriceInfo.price floatValue] - [bitMexBtcPriceInfo.price floatValue]) < -50) {
        NSLog(@"[Vincent : diff > -50 sell bitMex BTC On %@]", bitMexBtcPriceInfo.price);
    } else if (([binanceBtcPriceInfo.price floatValue] - [bitMexBtcPriceInfo.price floatValue]) < -45) {
        NSLog(@"[Vincent : diff > -45 sell bitMex BTC On %@]", bitMexBtcPriceInfo.price);
    } else if (([binanceBtcPriceInfo.price floatValue] - [bitMexBtcPriceInfo.price floatValue]) < -40) {
        NSLog(@"[Vincent : diff > -40 sell bitMex BTC On %@]", bitMexBtcPriceInfo.price);
    } else if (([binanceBtcPriceInfo.price floatValue] - [bitMexBtcPriceInfo.price floatValue]) < -35) {
        NSLog(@"[Vincent : diff > -35 sell bitMex BTC On %@]", bitMexBtcPriceInfo.price);
    } else if (([binanceBtcPriceInfo.price floatValue] - [bitMexBtcPriceInfo.price floatValue]) < -30) {
        NSLog(@"[Vincent : diff > -30 sell bitMex BTC On %@]", bitMexBtcPriceInfo.price);
    }
}

@end
