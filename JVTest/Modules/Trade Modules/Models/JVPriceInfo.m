//
//  JVPriceInfo.m
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/21.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import "JVPriceInfo.h"

@implementation JVPriceInfo

- (instancetype)initWithBinanceSocketJSON:(NSDictionary *)JSON {
    if (self = [super init]) {
        _symbol = JSON[@"s"];
        _close = @([JSON[@"c"] floatValue]);
        _volume = @([JSON[@"Q"] floatValue]);
        _timeStamp = [JSON[@"E"] integerValue];
        
    }
    
    return self;
}

//    1499040000000,      // Open time
//    "0.01634790",       // Open
//    "0.80000000",       // High
//    "0.01575800",       // Low
//    "0.01577100",       // Close
//    "148976.11427815",  // Volume
- (instancetype)initWithBinanceApiArrayInfo:(NSArray *)arrayInfo {
    if (self = [super init]) {
        NSNumber *timeStamp = arrayInfo[0];
        NSString *open = arrayInfo[1];
        NSString *height = arrayInfo[2];
        NSString *low = arrayInfo[3];
        NSString *close = arrayInfo[4];
        NSString *volume = arrayInfo[5];
        
        _timeStamp = [timeStamp integerValue];
        _open = @([open floatValue]);
        _height = @([height floatValue]);
        _low = @([low floatValue]);
        _close = @([close floatValue]);
        _volume = @([volume floatValue]);
        
    }
    
    return self;
}

- (instancetype)initWithBitMexJSON:(NSDictionary *)JSON {
    if (self = [super init]) {
        _symbol = [JSON[@"data"] firstObject][@"symbol"];
        _close = [JSON[@"data"] firstObject][@"lastPrice"];
    }
    
    return self;
}

- (NSString *)description {
    [NSString stringWithFormat:@"Price : %@, quantity : %@, TimeStamp: %@", self.close, self.volume, @(self.timeStamp)];
    return [self.close stringValue];
}

#pragma mark - getter

- (NSDate *)date {
    if (!_timeStamp) {
        return nil;
    }
    
    return [NSDate dateWithTimeIntervalSince1970:self.timeStamp/1000];
}

- (NSInteger)nextSecondTimeStamp {
    if (!_timeStamp) {
        return 0;
    }
    
    return _timeStamp + 1000;
}

@end
