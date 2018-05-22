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
        self.symbol = JSON[@"s"];
        self.price = @([JSON[@"c"] floatValue]);
    }
    
    return self;
}

- (instancetype)initWithBitMexJSON:(NSDictionary *)JSON {
    if (self = [super init]) {
        self.symbol = [JSON[@"data"] firstObject][@"symbol"];
        self.price = [JSON[@"data"] firstObject][@"lastPrice"];
    }
    
    return self;
}

- (NSString *)description {
    return [self.price stringValue];
}

@end
