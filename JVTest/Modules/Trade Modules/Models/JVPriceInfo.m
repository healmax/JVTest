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

- (instancetype)initWithBinanceJSON:(NSDictionary *)JSON {
    if (!JSON) {
        return nil;
    }
    
    if (self = [super init]) {
        _sourceName = @"Binance";
        _symbol = JSON[@"s"];
        _price = @([JSON[@"c"] floatValue]);
        _quantity = @([JSON[@"Q"] floatValue]);
        _timeStamp = [JSON[@"E"] integerValue];
        
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
        _price = dict[@"lastPrice"];
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
    return [NSString stringWithFormat:@"Source:%@ Price : %@, quantity : %@, Date: %@", self.sourceName, self.price, self.quantity, self.date];;
}

#pragma mark - Accessor

- (double)priceValue {
    return [self.price doubleValue];
}

- (NSDate *)date {
    return [NSDate dateWithTimeIntervalSince1970:self.timeStamp / 1000];
}

@end
