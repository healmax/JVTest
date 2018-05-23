//
//  JVPriceInfo.h
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/21.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVPriceInfo : NSObject

@property (copy, nonatomic, readonly) NSString *symbol;
@property (strong, nonatomic, readonly) NSNumber *price;
@property (strong, nonatomic, readonly) NSNumber *quantity;
@property (assign, nonatomic, readonly) NSUInteger timeStamp;

- (instancetype)initWithBinanceJSON:(NSDictionary *)JSON;
- (instancetype)initWithBitMexJSON:(NSDictionary *)JSON;

@end
