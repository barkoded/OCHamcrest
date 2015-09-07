//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 hamcrest.org. See LICENSE.txt

#import "HCTestFailureHandlerChain.h"

#import "HCTestFailureHandler.h"

#import <SenTestingKit/SenTestingKit.h>


@interface TestFailureHandlerChainTests : SenTestCase
@end

@implementation TestFailureHandlerChainTests

- (void)tearDown
{
    [HCTestFailureHandlerChain reset];
    [super tearDown];
}

- (void)testDefaultChain_ShouldPointToXCTestHandlerAsHeadOfChain
{
    HCTestFailureHandler *handler = [HCTestFailureHandlerChain chain];

    STAssertEqualObjects(NSStringFromClass([handler class]), @"HCXCTestFailureHandler", nil);
    STAssertNotNil(handler.successor, nil);
}

- (void)testDeprecatedFunction_ShouldPointToXCTestHandlerAsHeadOfChain
{
    HCTestFailureHandler *handler = HC_testFailureHandlerChain();

    STAssertEqualObjects(NSStringFromClass([handler class]), @"HCXCTestFailureHandler", nil);
    STAssertNotNil(handler.successor, nil);
}

- (void)testAddHandler_ShouldSetHeadOfChainToGivenHandler
{
    HCTestFailureHandler *newHandler = [[HCTestFailureHandler alloc] init];

    [HCTestFailureHandlerChain addHandler:newHandler];

    STAssertEquals([HCTestFailureHandlerChain chain], newHandler, nil);
}

- (void)testAddHandler_ShouldSetHandlerSuccessorToPreviousHeadOfChain
{
    HCTestFailureHandler *newHandler = [[HCTestFailureHandler alloc] init];
    HCTestFailureHandler *oldHead = [HCTestFailureHandlerChain chain];
    
    [HCTestFailureHandlerChain addHandler:newHandler];
    
    STAssertEquals(newHandler.successor, oldHead, nil);
}

- (void)testAddHandler_ShouldSetHandlerSuccessorEvenIfHeadOfChainHasNotBeenReferenced
{
    HCTestFailureHandler *newHandler = [[HCTestFailureHandler alloc] init];

    [HCTestFailureHandlerChain addHandler:newHandler];

    STAssertNotNil(newHandler.successor, nil);
}

@end
