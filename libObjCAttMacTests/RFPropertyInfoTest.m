//
//  RFPropertyInfoTest.m
//  libObjCAttr
//
//  Created by mac on 2017/8/17.
//  Copyright © 2017年 Epam Systems. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ROADAttribute.h"
#import "RFPropertyInfo.h"

@interface RFPropertyInfoTestObject : NSObject
@property(nonatomic,strong,readonly) NSString *name;
@property(nonatomic,assign) NSInteger integer;
@property(nonatomic,readonly) int intt;
@property(nonatomic,assign) BOOL b;
@property(nonatomic,copy) dispatch_block_t block;
@property(nonatomic,strong) RFPropertyInfoTestObject *object;
@property(nonatomic,weak) NSObject<NSCopying,  NSObject> *nn;
@property(nonatomic,weak) id kit;
@end

@implementation RFPropertyInfoTestObject


@end
@interface RFPropertyInfoTest : XCTestCase

@end

@implementation RFPropertyInfoTest

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    NSArray *propertys = [RFPropertyInfo propertiesForClass:[RFPropertyInfoTestObject class]];
    XCTAssert(propertys.count == 6);
    XCTAssert([propertys[0] encodingType] == RFEncodingTypeObject);
    XCTAssert(([propertys[0] encodingSpecifier] & RFEncodingSpecifierReadonly) == RFEncodingSpecifierReadonly);
    XCTAssert(([propertys[0] encodingSpecifier] & RFEncodingSpecifierRetain) == RFEncodingSpecifierRetain);
    XCTAssert(([propertys[0] encodingSpecifier] & RFEncodingSpecifierNonatomic) == RFEncodingSpecifierNonatomic);

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
