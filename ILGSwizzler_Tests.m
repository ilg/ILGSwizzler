//
//  ILGSwizzler_Tests.m
//
//  Created by Isaac Greenspan on 1/23/13.
//
//

#import "ILGSwizzler_Tests.h"
#import "ILGSwizzler.h"

@interface ILGSwizzler_Tests_target : NSObject
+ (NSUInteger)returnsZero;
- (NSUInteger)returnsZero;
@end
@implementation ILGSwizzler_Tests_target
+ (NSUInteger)returnsZero { return 0; }
- (NSUInteger)returnsZero { return 0; }
@end

@interface ILGSwizzler_Tests_source : NSObject
+ (NSUInteger)returnsZero;
- (NSUInteger)returnsZero;
@end
@implementation ILGSwizzler_Tests_source
+ (NSUInteger)returnsZero { return NSNotFound; }
- (NSUInteger)returnsZero { return NSNotFound; }
@end

@implementation ILGSwizzler_Tests

- (void)testInstanceSwizzleFromClass
{
    // Check default behavior.
    STAssertEquals([ILGSwizzler_Tests_target returnsZero], (NSUInteger)0, @"Pre-swizzle class implementation failed to return 0.");
    ILGSwizzler_Tests_target *target = [[ILGSwizzler_Tests_target alloc] init];
    STAssertEquals([target returnsZero], (NSUInteger)0, @"Pre-swizzle default instance implementation failed to return 0.");
    [target release];
    target = nil;
    
    // Do the swizzling.
    ILGSwizzler *swizzler = [[ILGSwizzler alloc] init];
    [swizzler replaceImplementationOfInstanceSelector:@selector(returnsZero)
                                              onClass:[ILGSwizzler_Tests_target class]
                          withImplementationFromClass:[ILGSwizzler_Tests_source class]];
    
    // Check swizzled behavior.
    target = [[ILGSwizzler_Tests_target alloc] init];
    STAssertEquals([target returnsZero], NSNotFound, @"Swizzled replacement instance implementation failed to return NSNotFound.");
    STAssertEquals([ILGSwizzler_Tests_target returnsZero], (NSUInteger)0, @"Instance swizzling caused class implementation to fail to return 0.");
    [target release];
    target = nil;
    
    // Un-swizzle.
    [swizzler done];
    [swizzler release];
    swizzler = nil;
    
    // Re-check default behavior.
    target = [[ILGSwizzler_Tests_target alloc] init];
    STAssertEquals([target returnsZero], (NSUInteger)0, @"Post-swizzle-un-swizzle instance implementation failed to return 0.");
    STAssertEquals([ILGSwizzler_Tests_target returnsZero], (NSUInteger)0, @"Instance swizzling caused class implementation to fail to return 0 (after un-swizzle).");
    [target release];
    target = nil;
}

- (void)testClassSwizzleFromClass
{
    // Check default behavior.
    STAssertEquals([ILGSwizzler_Tests_target returnsZero], (NSUInteger)0, @"Pre-swizzle default class implementation failed to return 0.");
    ILGSwizzler_Tests_target *target = [[ILGSwizzler_Tests_target alloc] init];
    STAssertEquals([target returnsZero], (NSUInteger)0, @"Pre-swizzle instance implementation failed to return 0.");
    [target release];
    target = nil;
    
    // Do the swizzling.
    ILGSwizzler *swizzler = [[ILGSwizzler alloc] init];
    [swizzler replaceImplementationOfClassSelector:@selector(returnsZero)
                                           onClass:[ILGSwizzler_Tests_target class]
                       withImplementationFromClass:[ILGSwizzler_Tests_source class]];
    
    // Check swizzled behavior.
    target = [[ILGSwizzler_Tests_target alloc] init];
    STAssertEquals([target returnsZero], (NSUInteger)0, @"Class swizzling caused instance implementation to fail to return 0.");
    STAssertEquals([ILGSwizzler_Tests_target returnsZero], NSNotFound, @"Swizzled replacement class implementation failed to return NSNotFound.");
    [target release];
    target = nil;
    
    // Un-swizzle.
    [swizzler done];
    [swizzler release];
    swizzler = nil;
    
    // Re-check default behavior.
    target = [[ILGSwizzler_Tests_target alloc] init];
    STAssertEquals([target returnsZero], (NSUInteger)0, @"Class swizzling caused instance implementation to fail to return 0 (after un-swizzle).");
    STAssertEquals([ILGSwizzler_Tests_target returnsZero], (NSUInteger)0, @"Post-swizzle-un-swizzle class implementation failed to return 0.");
    [target release];
    target = nil;
}

- (void)testInstanceSwizzleFromBlock
{
    // Check default behavior.
    STAssertEquals([ILGSwizzler_Tests_target returnsZero], (NSUInteger)0, @"Pre-swizzle class implementation failed to return 0.");
    ILGSwizzler_Tests_target *target = [[ILGSwizzler_Tests_target alloc] init];
    STAssertEquals([target returnsZero], (NSUInteger)0, @"Pre-swizzle default instance implementation failed to return 0.");
    [target release];
    target = nil;
    
    // Do the swizzling.
    ILGSwizzler *swizzler = [[ILGSwizzler alloc] init];
    [swizzler replaceImplementationOfInstanceSelector:@selector(returnsZero)
                                              onClass:[ILGSwizzler_Tests_target class]
                                            withBlock:^(id s){ return NSNotFound; }];
    
    // Check swizzled behavior.
    target = [[ILGSwizzler_Tests_target alloc] init];
    STAssertEquals([target returnsZero], NSNotFound, @"Swizzled replacement instance implementation failed to return NSNotFound.");
    STAssertEquals([ILGSwizzler_Tests_target returnsZero], (NSUInteger)0, @"Instance swizzling caused class implementation to fail to return 0.");
    [target release];
    target = nil;
    
    // Un-swizzle.
    [swizzler done];
    [swizzler release];
    swizzler = nil;
    
    // Re-check default behavior.
    target = [[ILGSwizzler_Tests_target alloc] init];
    STAssertEquals([target returnsZero], (NSUInteger)0, @"Post-swizzle-un-swizzle instance implementation failed to return 0.");
    STAssertEquals([ILGSwizzler_Tests_target returnsZero], (NSUInteger)0, @"Instance swizzling caused class implementation to fail to return 0 (after un-swizzle).");
    [target release];
    target = nil;
}

- (void)testClassSwizzleFromBlock
{
    // Check default behavior.
    STAssertEquals([ILGSwizzler_Tests_target returnsZero], (NSUInteger)0, @"Pre-swizzle default class implementation failed to return 0.");
    ILGSwizzler_Tests_target *target = [[ILGSwizzler_Tests_target alloc] init];
    STAssertEquals([target returnsZero], (NSUInteger)0, @"Pre-swizzle instance implementation failed to return 0.");
    [target release];
    target = nil;
    
    // Do the swizzling.
    ILGSwizzler *swizzler = [[ILGSwizzler alloc] init];
    [swizzler replaceImplementationOfClassSelector:@selector(returnsZero)
                                           onClass:[ILGSwizzler_Tests_target class]
                                         withBlock:^NSUInteger(id s){ return NSNotFound; }];
    
    // Check swizzled behavior.
    target = [[ILGSwizzler_Tests_target alloc] init];
    STAssertEquals([target returnsZero], (NSUInteger)0, @"Class swizzling caused instance implementation to fail to return 0.");
    STAssertEquals([ILGSwizzler_Tests_target returnsZero], NSNotFound, @"Swizzled replacement class implementation failed to return NSNotFound.");
    [target release];
    target = nil;
    
    // Un-swizzle.
    [swizzler done];
    [swizzler release];
    swizzler = nil;
    
    // Re-check default behavior.
    target = [[ILGSwizzler_Tests_target alloc] init];
    STAssertEquals([target returnsZero], (NSUInteger)0, @"Class swizzling caused instance implementation to fail to return 0 (after un-swizzle).");
    STAssertEquals([ILGSwizzler_Tests_target returnsZero], (NSUInteger)0, @"Post-swizzle-un-swizzle class implementation failed to return 0.");
    [target release];
    target = nil;
}

- (void)testDoubleClassSwizzleFromBlock
{
    // Check default behavior.
    STAssertEquals([ILGSwizzler_Tests_target returnsZero], (NSUInteger)0, @"Pre-swizzle default class implementation failed to return 0.");
    
    // Do the first swizzling.
    ILGSwizzler *swizzler = [[ILGSwizzler alloc] init];
    [swizzler replaceImplementationOfClassSelector:@selector(returnsZero)
                                           onClass:[ILGSwizzler_Tests_target class]
                                         withBlock:^NSUInteger(id s){ return NSNotFound; }];
    
    // Check swizzled behavior.
    STAssertEquals([ILGSwizzler_Tests_target returnsZero], NSNotFound, @"Swizzled (first) replacement class implementation failed to return NSNotFound.");
    
    // Do the second swizzling.
    [swizzler replaceImplementationOfClassSelector:@selector(returnsZero)
                                           onClass:[ILGSwizzler_Tests_target class]
                                         withBlock:^NSUInteger(id s){ return 42; }];
    
    // Check swizzled behavior.
    STAssertEquals([ILGSwizzler_Tests_target returnsZero], (NSUInteger)42, @"Swizzled (second) replacement class implementation failed to return 42.");
    
    // Un-swizzle.
    [swizzler done];
    [swizzler release];
    swizzler = nil;
    
    // Re-check default behavior.
    STAssertEquals([ILGSwizzler_Tests_target returnsZero], (NSUInteger)0, @"Post-swizzle-un-swizzle class implementation failed to return 0.");
}

- (void)testDoubleInstanceSwizzleFromBlock
{
    // Check default behavior.
    ILGSwizzler_Tests_target *target = [[ILGSwizzler_Tests_target alloc] init];
    STAssertEquals([target returnsZero], (NSUInteger)0, @"Pre-swizzle default instance implementation failed to return 0.");
    [target release];
    target = nil;
    
    // Do the first swizzling.
    ILGSwizzler *swizzler = [[ILGSwizzler alloc] init];
    [swizzler replaceImplementationOfInstanceSelector:@selector(returnsZero)
                                              onClass:[ILGSwizzler_Tests_target class]
                                            withBlock:^(id s){ return NSNotFound; }];
    
    // Check swizzled behavior.
    target = [[ILGSwizzler_Tests_target alloc] init];
    STAssertEquals([target returnsZero], NSNotFound, @"Swizzled (first) replacement instance implementation failed to return NSNotFound.");
    [target release];
    target = nil;
    
    // Do the second swizzling.
    [swizzler replaceImplementationOfInstanceSelector:@selector(returnsZero)
                                              onClass:[ILGSwizzler_Tests_target class]
                                            withBlock:^(id s){ return 42; }];
    
    // Check swizzled behavior.
    target = [[ILGSwizzler_Tests_target alloc] init];
    STAssertEquals([target returnsZero], (NSUInteger)42, @"Swizzled (second) replacement instance implementation failed to return 42.");
    [target release];
    target = nil;
    
    // Un-swizzle.
    [swizzler done];
    [swizzler release];
    swizzler = nil;
    
    // Re-check default behavior.
    target = [[ILGSwizzler_Tests_target alloc] init];
    STAssertEquals([target returnsZero], (NSUInteger)0, @"Post-swizzle-un-swizzle instance implementation failed to return 0.");
    [target release];
    target = nil;
}

@end
