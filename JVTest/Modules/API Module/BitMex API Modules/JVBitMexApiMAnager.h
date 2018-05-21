//
//  JVBitMexApiMAnager.h
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/21.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFURLSessionManager;

@interface JVBitMexApiMAnager : NSObject

+(instancetype)sharedManager;

@property (strong, nonatomic, readonly) AFURLSessionManager *manager; // compose

@end
