//
//  JVPriceInfo.h
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/21.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVPriceInfo : NSObject

@property (copy, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSNumber *price;

- (instancetype)initWithBinanceJSON:(NSDictionary *)JSON;
- (instancetype)initWithBitMexJSON:(NSDictionary *)JSON;

@end
