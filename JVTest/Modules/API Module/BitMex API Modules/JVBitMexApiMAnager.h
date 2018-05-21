//
//  JVBitMexApiMAnager.h
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/21.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperationManager;

@interface JVBitMexApiMAnager : NSObject

+(instancetype)sharedManager;

@property (strong, nonatomic, readonly) AFHTTPRequestOperationManager *manager; // compose

@end
