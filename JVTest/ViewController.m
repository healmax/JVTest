//
//  ViewController.m
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/21.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import "ViewController.h"
#import "JVBitMexSocketManager.h"
#import "JVBinanceSocketManager.h"
#import "JVPriceInfo.h"
#import "JVBtcTradeManager.h"
#import "JVBinanceApiManager.h"
#import "JVBinanceHistoryDownloader.h"
#import "JVPriceInfo.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *binancePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mexPriceLabel;

@property (strong, nonatomic) JVBinanceHistoryDownloader *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
    [JVBtcTradeManager shareInstance];
    self.manager = [[JVBinanceHistoryDownloader alloc] init];
    [self.manager downloadOneMinKBarHistory];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)commonInit {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(binanceSocketManagerDidReceiveMessage:) name:kJVBinanceSocketManagerDidReceiveMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bitMexSocketManagerDidReceiveMessage:) name:kJVBitMexSocketManagerDidReceiveMessage object:nil];

}

- (void)binanceSocketManagerDidReceiveMessage:(NSNotification *)notification {
    JVPriceInfo *priceInfo = notification.object;
    self.binancePriceLabel.text = [priceInfo description];
}

- (void)bitMexSocketManagerDidReceiveMessage:(NSNotification *)notification {
    JVPriceInfo *priceInfo = notification.object;
    self.mexPriceLabel.text = [priceInfo description];
}





@end
