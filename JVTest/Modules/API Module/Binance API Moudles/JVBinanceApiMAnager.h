//
//  JVBinanceApiMAnager.h
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/21.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPSessionManager;
@class JVPriceInfo;

@interface JVBinanceApiMAnager : NSObject

+(instancetype)sharedManager;

@property (strong, nonatomic, readonly) AFHTTPSessionManager *manager; // compose

- (void)getBTCPriceWithCompletion:(void(^)(JVPriceInfo *priceInfo, NSError *error))completion;

@end
