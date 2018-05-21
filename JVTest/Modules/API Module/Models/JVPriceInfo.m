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
        self.coinToCoin = JSON[@"symbol"];
        self.price = JSON[@"price"];
    }
    
    return self;
}

@end
