//
//  OCHamcrest - HCInvocationMatcher.mm
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

    // Self
#import "HCInvocationMatcher.h"

    // OCHamcrest
#import "HCDescription.h"


@implementation HCInvocationMatcher

+ (NSInvocation*) invocationForSelector:(SEL)selector onClass:(Class)aClass
{
    NSMethodSignature* signature = [aClass instanceMethodSignatureForSelector:selector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:selector];
    return invocation;
}


+ (NSInvocation*) createInvocationForSelector:(SEL)selector onClass:(Class)aClass
{
    return [self invocationForSelector:selector onClass:aClass];
}


- (id) initWithInvocation:(NSInvocation*)anInvocation matching:(id<HCMatcher>)aMatcher
{
    self = [super init];
    if (self != nil)
    {
        invocation = [anInvocation retain];
        subMatcher = [aMatcher retain];
    }
    return self;
}


- (void) dealloc
{
    [subMatcher release];
    [invocation release];
    
    [super dealloc];
}


- (NSString*) stringFromSelector
{
    return NSStringFromSelector([invocation selector]);
}


- (BOOL) matches:(id)item
{
    return [self matches:item describingMismatchTo:nil];
}


- (BOOL) matches:(id)item describingMismatchTo:(id<HCDescription>)mismatchDescription
{
    if (![item respondsToSelector:[invocation selector]])
    {
        [super describeMismatchOf:item to:mismatchDescription];
        return NO;
    }
        
    id invocationResult = nil;
    [invocation invokeWithTarget:item];
    [invocation getReturnValue:&invocationResult];
    
    if (![subMatcher matches:invocationResult])
    {
        [[mismatchDescription appendText:[self stringFromSelector]] appendText:@" "];
        [subMatcher describeMismatchOf:invocationResult to:mismatchDescription];
        return NO;
    }
    
    return YES;
}


- (void) describeTo:(id<HCDescription>)description
{
    [[[[description appendText:@"with "]
                    appendText:[self stringFromSelector]]
                    appendText:@" "]
                    appendDescriptionOf:subMatcher];
}

@end