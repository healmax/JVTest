//
//  JVPriceInfo.m
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/21.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import "JVPriceInfo.h"

@implementation JVPriceInfo

- (instancetype)initWithBinanceJSON:(NSDictionary *)JSON {
    if (self = [super init]) {
        _symbol = JSON[@"s"];
        _price = @([JSON[@"c"] floatValue]);
        _quantity = @([JSON[@"Q"] floatValue]);
        _timeStamp = [JSON[@"E"] integerValue];
        
    }
    
    return self;
}

- (instancetype)initWithBitMexJSON:(NSDictionary *)JSON {
    if (self = [super init]) {
        _symbol = [JSON[@"data"] firstObject][@"symbol"];
        _price = [JSON[@"data"] firstObject][@"lastPrice"];
    }
    
    return self;
}

- (NSString *)description {
    [NSString stringWithFormat:@"Price : %@, quantity : %@, TimeStamp: %@", self.price, self.quantity, @(self.timeStamp)];
    return [self.price stringValue];
}

@end
