
//
//  JVBinanceHistoryManager.m
//  JVTest
//
//  Created by Vincent Chiang on 2018/5/27.
//  Copyright © 2018年 Vincent Chiang. All rights reserved.
//

#import "JVBinanceHistoryDownloader.h"
#import "JVBinanceApiManager.h"
#import "JVUtils.h"
#import "JVPriceInfo.h"

//毫秒
static NSInteger const kStartTimeTimeStamp = 1503360000000;
static NSString * const kFileCategory = @"BinanceHistory";
static NSString * const kFileName = @"BinanceKLineHistory.txt";

@interface JVBinanceHistoryDownloader()

@property(strong, nonatomic) NSFileHandle *fileHandler;
@property (strong, nonatomic) dispatch_queue_t diskIOQueue;

@end

@implementation JVBinanceHistoryDownloader

- (instancetype)init {
    if (self = [super init]) {
        _diskIOQueue = dispatch_queue_create([@"com.JVText.diskIOQueue.BinanceKLine" UTF8String], DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (NSString *)rootPath {
    return [[[JVUtils sharedInstance] cacheDirectory] stringByAppendingPathComponent:kFileCategory];
}

- (NSString *)filePath {
    return [[self rootPath] stringByAppendingPathComponent:kFileName];
}

- (NSFileHandle *)fileHandler {
    if (!_fileHandler) {
        _fileHandler = [NSFileHandle fileHandleForWritingAtPath:[self filePath]];
    }
    
    return _fileHandler;
}

- (void)test {
    [self downloadKLineWithStartTimeStamp:kStartTimeTimeStamp];
}


- (void)downloadKLineWithStartTimeStamp:(NSUInteger)timeStamp {
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self rootPath]]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[self rootPath] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self filePath]]) {
        [[NSFileManager defaultManager] createFileAtPath:[self filePath] contents:nil attributes:nil];
        NSString *contents = @"\"Date\",\"Time\",\"Open\",\"High\",\"Low\",\"Close\",\"TotalVolume\"\n";
        [contents writeToFile:[self filePath] atomically:YES encoding: NSUnicodeStringEncoding error:&error];
    }

    __weak typeof(self) weakSelf = self;
    [[JVBinanceApiManager sharedManager] getBTCHistoryWithStartTimeTimeStamp:timeStamp completion:^(NSArray<JVPriceInfo *> *priceInfos, NSError *error) {
        @autoreleasepool
        {
            dispatch_async(weakSelf.diskIOQueue, ^{
                NSDateFormatter *dateFormatter = [[JVUtils sharedInstance] dateFormatter];
                [weakSelf.fileHandler seekToEndOfFile];
                for (JVPriceInfo *priceInfo in priceInfos) {
                    [weakSelf.fileHandler seekToEndOfFile];
                    NSString *multiChartInfo = [NSString stringWithFormat:@"%@,%.6f,%.6f,%.6f,%.6f,%ld\n", [dateFormatter stringFromDate:priceInfo.date], [priceInfo.open floatValue], [priceInfo.height floatValue], [priceInfo.low floatValue], [priceInfo.close floatValue], (long)[priceInfo.volume integerValue]];

                    NSData *data = [multiChartInfo dataUsingEncoding:NSUnicodeStringEncoding];
                    [weakSelf.fileHandler writeData:data];
                    [weakSelf.fileHandler synchronizeFile];
                }
                
                
                NSInteger nextTimeStamp = [priceInfos lastObject].nextSecondTimeStamp/1000;
                NSInteger nowTimeStamp = [[[NSDate alloc] init] timeIntervalSince1970];
                if (nowTimeStamp - nextTimeStamp > 60) {
                    [weakSelf downloadKLineWithStartTimeStamp:[priceInfos lastObject].nextSecondTimeStamp];
                } else {
                    [weakSelf.fileHandler closeFile];
                }
            });
        }
    }];
    

}





@end
