//
//  JVPriceInfo.m
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/21.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import "JVPriceInfo.h"

static NSDateFormatter *bitMexDateFormatter;

@implementation JVPriceInfo

- (instancetype)initWithBinanceSocketJSON:(NSDictionary *)JSON {
    if (self = [super init]) {
        _sourceName = @"Binance";
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
    NSDictionary *dict = [JSON[@"data"] firstObject];
    if (!dict) {
        return nil;
    }
    
    [self setupBitMexDateFormatter];
    
    if (self = [super init]) {
        _sourceName = @"BitMex";
        _symbol = dict[@"symbol"];
        _close = dict[@"lastPrice"];
        _timeStamp = [[bitMexDateFormatter dateFromString:dict[@"timestamp"]] timeIntervalSince1970] * 1000;
    }
    
    return self;
}

- (void)setupBitMexDateFormatter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bitMexDateFormatter = [[NSDateFormatter alloc] init];
        [bitMexDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];//2018-05-27T14:29:25.910Z
        [bitMexDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    });
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Source:%@ Price : %@, quantity : %@, Date: %@", self.sourceName, self.close, self.volume, self.date];;
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

#pragma mark - Accessor

- (double)priceValue {
    return [self.close doubleValue];
}



@end
