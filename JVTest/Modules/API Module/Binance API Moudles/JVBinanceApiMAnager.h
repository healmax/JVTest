//
//  JVBinanceApiMAnager.h
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/21.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperationManager;
@class JVPriceInfo;

@interface JVBinanceApiMAnager : NSObject

+(instancetype)sharedManager;

@property (strong,nonatomic, readonly) AFHTTPRequestOperationManager *manager; // compose

- (void)getBTCPriceWithCompletion:(void(^)(JVPriceInfo *priceInfo, NSError *error))completion;

@end
