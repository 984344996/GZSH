//
//  JKNetworkTest.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/23.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JKNetworkHelper.h"
@interface JKNetworkTest : XCTestCase

@end

@implementation JKNetworkTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

// TEST OK
- (void)testJKNetworkDownload{
    //拼接缓存目录
    NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: @"Download"];
    NSLog(@"%@", downloadDir);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"异步下载"];
    [JKNetworkHelper downLoadWithURL:@"https://infomedia-image.oss-cn-beijing.aliyuncs.com/muzhichat/145638578131404qalos5e2whr529.png" parameters:nil fileDir:nil progress:^(NSProgress * _Nonnull progress) {
        NSLog(@"progress %lld \n",progress.completedUnitCount / progress.totalUnitCount);
    } success:^(id  _Nonnull responseObject) {
        NSLog(@"download success");
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"download failed %@",error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}


// TEST OK
- (void)testJKNetworkCache{
    XCTestExpectation *expectation = [self expectationWithDescription:@"异步请求"];
    [JKNetworkHelper GET:@"https://test.mzliaoba.com/api/index" parameters:nil cache:^(id  _Nonnull cacheObject) {
        NSLog(@"cache is %@",cacheObject);
    } success:^(id  _Nonnull responseObject) {
        NSLog(@"response is %@",responseObject);
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error) {
         NSLog(@"download failed %@",error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
