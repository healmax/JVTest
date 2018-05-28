//
//  JVPriceGapAlgorithm.m
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/24.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import "JVPriceGapAlgorithm.h"
#import "JVBinanceSocketManager.h"
#import "JVBitMexSocketManager.h"
#import "JVPriceInfo.h"

static NSInteger const kMaxHistoryCount = 60;

@interface JVPriceGapAlgorithm()

@property (strong, nonatomic, readwrite) NSMutableArray<JVPriceInfo *> *binanceHistory;
@property (strong, nonatomic, readwrite) NSMutableArray<JVPriceInfo *> *bitMexHistory;

//是否已經有單子
@property (assign, nonatomic) BOOL alreadyTransaction;

@end

@implementation JVPriceGapAlgorithm

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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJVBinanceSocketManagerDidReceiveMessage object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJVBitMexSocketManagerDidReceiveMessage object:nil];
}

- (void)binanceSocketManagerDidReceiveMessage:(NSNotification *)notification {
    JVPriceInfo *priceInfo = notification.object;
    @synchronized(self) {
        if (!priceInfo) {
            return;
        }
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
        if (!priceInfo) {
            return;
        }
        if (self.bitMexHistory.count >= kMaxHistoryCount) {
            [self.bitMexHistory removeObjectAtIndex:0];
        }
        [self.bitMexHistory addObject:priceInfo];
    }
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
    
    float quantity = 0;
    NSInteger inRangeCount = 0;
    
    for (int index = 0; index < self.binanceHistory.count - 1; index++) {
        JVPriceInfo *firstInfo = self.binanceHistory[index];
        BOOL isInRange = ((binanceBtcPriceInfo.timeStamp - firstInfo.timeStamp) / 1000) < 30 ? YES : NO;
        if (!isInRange) {
            continue;
        }
        inRangeCount++;
        
        quantity += [firstInfo.volume floatValue];
        double diffValue = self.binanceHistory[index+1].priceValue - self.binanceHistory[index].priceValue;
        if (diffValue > 0) {
            [positiveDiff addObject:@(diffValue)];
            positiveCount++;
        }
        
        if (diffValue < 0) {
            [negativeDiff addObject:@(diffValue)];
            negativeCount++;
        }
    }
    
    static NSInteger count30 = 0;
    static NSInteger count35 = 0;
    static NSInteger count40 = 0;
    static NSInteger count45 = 0;
    static NSInteger count50 = 0;
    
    NSString *isgrather30 = quantity > 30 ? @"YES" : @"NO";
    if (([binanceBtcPriceInfo.close floatValue] - [bitMexBtcPriceInfo.close floatValue]) > 50) {
        count50++;
        NSLog(@"[Vincent : binance price - bitMex price > 50] \"binance price : %@\", \"bitMex price : %@\", \"count : %@\", \"quantity > 30 : %@\" ", binanceBtcPriceInfo.close, bitMexBtcPriceInfo.close, @(count50), isgrather30);
    } else if (([binanceBtcPriceInfo.close floatValue] - [bitMexBtcPriceInfo.close floatValue]) > 45) {
        count45++;
        NSLog(@"[Vincent : binance price - bitMex price > 45] \"binance price : %@\", \"bitMex price : %@\", \"count : %@\", \"quantity > 30 : %@\" ", binanceBtcPriceInfo.close, bitMexBtcPriceInfo.close, @(count45), isgrather30);
    } else if (([binanceBtcPriceInfo.close floatValue] - [bitMexBtcPriceInfo.close floatValue]) > 40) {
        count40++;
        NSLog(@"[Vincent : binance price - bitMex price > 40] \"binance price : %@\", \"bitMex price : %@\", \"count : %@\", \"quantity > 30 : %@\" ", binanceBtcPriceInfo.close, bitMexBtcPriceInfo.close, @(count40), isgrather30);
    } else if (([binanceBtcPriceInfo.close floatValue] - [bitMexBtcPriceInfo.close floatValue]) > 35) {
        count35++;
        NSLog(@"[Vincent : binance price - bitMex price > 35] \"binance price : %@\", \"bitMex price : %@\", \"count : %@\", \"quantity > 30 : %@\" ", binanceBtcPriceInfo.close, bitMexBtcPriceInfo.close, @(count35), isgrather30);
    } else if (([binanceBtcPriceInfo.close floatValue] - [bitMexBtcPriceInfo.close floatValue]) > 30) {
        count30++;
        NSLog(@"[Vincent : binance price - bitMex price > 30] \"binance price : %@\", \"bitMex price : %@\", \"count : %@\", \"quantity > 30 : %@\" ", binanceBtcPriceInfo.close, bitMexBtcPriceInfo.close, @(count30), isgrather30);
    }
    
    
    if (([binanceBtcPriceInfo.close floatValue] - [bitMexBtcPriceInfo.close floatValue]) < -50) {
        count50++;
        NSLog(@"[Vincent : binance price - bitMex price < -50] \"binance price : %@\", \"bitMex price : %@\", \"count : %@\", \"quantity > 30 : %@\" ", binanceBtcPriceInfo.close, bitMexBtcPriceInfo.close, @(count50), isgrather30);
    } else if (([binanceBtcPriceInfo.close floatValue] - [bitMexBtcPriceInfo.close floatValue]) < -45) {
        count45++;
        NSLog(@"[Vincent : binance price - bitMex price < -45] \"binance price : %@\", \"bitMex price : %@\", \"count : %@\", \"quantity > 30 : %@\" ", binanceBtcPriceInfo.close, bitMexBtcPriceInfo.close, @(count45), isgrather30);
    } else if (([binanceBtcPriceInfo.close floatValue] - [bitMexBtcPriceInfo.close floatValue]) < -40) {
        count40++;
        NSLog(@"[Vincent : binance price - bitMex price < -40] \"binance price : %@\", \"bitMex price : %@\", \"count : %@\", \"quantity > 30 : %@\" ", binanceBtcPriceInfo.close, bitMexBtcPriceInfo.close, @(count40), isgrather30);
    } else if (([binanceBtcPriceInfo.close floatValue] - [bitMexBtcPriceInfo.close floatValue]) < -35) {
        count35++;
        NSLog(@"[Vincent : binance price - bitMex price < -35] \"binance price : %@\", \"bitMex price : %@\", \"count : %@\", \"quantity > 30 : %@\" ", binanceBtcPriceInfo.close, bitMexBtcPriceInfo.close, @(count35), isgrather30);
    } else if (([binanceBtcPriceInfo.close floatValue] - [bitMexBtcPriceInfo.close floatValue]) < -30) {
        count30++;
        NSLog(@"[Vincent : binance price - bitMex price < -30] \"binance price : %@\", \"bitMex price : %@\", \"count : %@\", \"quantity > 30 : %@\" ", binanceBtcPriceInfo.close, bitMexBtcPriceInfo.close, @(count30), isgrather30);
    }
    
    //遞增或遞減的數目有超過10筆
    if (positiveCount < inRangeCount/2 && negativeCount < inRangeCount/2) {
        return;
    }
    
    if (quantity < 30) {
        return;
    }
    
    if (([binanceBtcPriceInfo.close floatValue] - [bitMexBtcPriceInfo.close floatValue]) > 50) {
        NSLog(@"[Vincent : diff > 50 buy bitMex BTC On %@]", bitMexBtcPriceInfo.close);
    } else if (([binanceBtcPriceInfo.close floatValue] - [bitMexBtcPriceInfo.close floatValue]) > 45) {
        NSLog(@"[Vincent : diff > 45 buy bitMex BTC On %@]", bitMexBtcPriceInfo.close);
    } else if (([binanceBtcPriceInfo.close floatValue] - [bitMexBtcPriceInfo.close floatValue]) > 40) {
        NSLog(@"[Vincent : diff > 40 buy bitMex BTC On %@]", bitMexBtcPriceInfo.close);
    } else if (([binanceBtcPriceInfo.close floatValue] - [bitMexBtcPriceInfo.close floatValue]) > 35) {
        NSLog(@"[Vincent : diff > 35 buy bitMex BTC On %@]", bitMexBtcPriceInfo.close);
    } else if (([binanceBtcPriceInfo.close floatValue] - [bitMexBtcPriceInfo.close floatValue]) > 30) {
        NSLog(@"[Vincent : diff > 30 buy bitMex BTC On %@]", bitMexBtcPriceInfo.close);
    }
    
    if (([binanceBtcPriceInfo.close floatValue] - [bitMexBtcPriceInfo.close floatValue]) < -50) {
        NSLog(@"[Vincent : diff > -50 sell bitMex BTC On %@]", bitMexBtcPriceInfo.close);
    } else if (([binanceBtcPriceInfo.close floatValue] - [bitMexBtcPriceInfo.close floatValue]) < -45) {
        NSLog(@"[Vincent : diff > -45 sell bitMex BTC On %@]", bitMexBtcPriceInfo.close);
    } else if (([binanceBtcPriceInfo.close floatValue] - [bitMexBtcPriceInfo.close floatValue]) < -40) {
        NSLog(@"[Vincent : diff > -40 sell bitMex BTC On %@]", bitMexBtcPriceInfo.close);
    } else if (([binanceBtcPriceInfo.close floatValue] - [bitMexBtcPriceInfo.close floatValue]) < -35) {
        NSLog(@"[Vincent : diff > -35 sell bitMex BTC On %@]", bitMexBtcPriceInfo.close);
    } else if (([binanceBtcPriceInfo.close floatValue] - [bitMexBtcPriceInfo.close floatValue]) < -30) {
        NSLog(@"[Vincent : diff > -30 sell bitMex BTC On %@]", bitMexBtcPriceInfo.close);
    }
}


@end
