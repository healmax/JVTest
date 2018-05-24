//
//  JVPriceGapAlgorithm.h
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/24.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JVPriceInfo;

@interface JVPriceGapAlgorithm : NSObject

@property (strong, nonatomic, readonly) NSMutableArray<JVPriceInfo *> *binanceHistory;
@property (strong, nonatomic, readonly) NSMutableArray<JVPriceInfo *> *bitMexHistory;

@end
