//
//  JKKeyValueTests.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/2/14.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KeyValueUtility.h"

@interface JKKeyValueTests : XCTestCase

@end

@implementation JKKeyValueTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

-(void)testGetValue{
    [self testSetValue];
    NSString *name = [KeyValueUtility getValueForFromPlist:@"userinfo" forKey:@"username"];
    NSString *pwd = [KeyValueUtility getValueForFromPlist:@"userinfo" forKey:@"password"];
    NSLog(@"%@ %@",name,pwd);
    XCTAssertNotNil(name);
    XCTAssertNotNil(pwd);
}

-(void)testSetValue{
    [KeyValueUtility setValueToPlist:@"userinfo" value:@"dengjie" forKey:@"username"];
    [KeyValueUtility setValueToPlist:@"userinfo" value:@"123" forKey:@"password"];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
