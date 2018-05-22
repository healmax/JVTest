//
//  ViewController.m
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/21.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import "ViewController.h"
#import "JVBinanceApiMAnager.h"
#import <SwaggerClient/SWGDefaultConfiguration.h>
#import <SwaggerClient/SWGAPIKeyApi.h>
#import "JVBitMexSocketManager.h"

@interface ViewController ()<SRWebSocketDelegate>

@property(strong, nonatomic) SRWebSocket *socket;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[JVBinanceApiMAnager sharedManager] getBTCPriceWithCompletion:^(JVPriceInfo *priceInfo, NSError *error) {
        
    }];
    
    [[JVBitMexSocketManager shareInstance] openSocket];
}


@end
