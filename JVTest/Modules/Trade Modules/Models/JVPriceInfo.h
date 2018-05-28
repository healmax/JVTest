//
//  JVPriceInfo.h
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/21.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVPriceInfo : NSObject

@property (copy, nonatomic, readonly) NSString *sourceName;
@property (copy, nonatomic, readonly) NSString *symbol;
@property (strong, nonatomic, readonly) NSNumber *close;
@property (strong, nonatomic, readonly) NSNumber *open;
@property (strong, nonatomic, readonly) NSNumber *height;
@property (strong, nonatomic, readonly) NSNumber *low;
@property (strong, nonatomic, readonly) NSNumber *volume;
@property (assign, nonatomic, readonly) NSTimeInterval timeStamp;
@property (assign, nonatomic, readonly) NSInteger nextSecondTimeStamp;
@property (strong, nonatomic, readonly) NSDate *date;
@property (assign, nonatomic, readonly) double priceValue;

- (instancetype)initWithBinanceApiArrayInfo:(NSArray *)arrayInfo;
- (instancetype)initWithBinanceSocketJSON:(NSDictionary *)JSON;
- (instancetype)initWithBitMexJSON:(NSDictionary *)JSON;

@end
