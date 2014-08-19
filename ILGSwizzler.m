//
//  ILGSwizzler.m
//
//  Created by Isaac Greenspan on 1/23/13.
//
//

#import "ILGSwizzler.h"
#import <objc/runtime.h>

@interface ILGSwizzler ()

@property (nonatomic, retain) NSMutableDictionary *originalClassMethodImplementations;
@property (nonatomic, retain) NSMutableDictionary *originalInstanceMethodImplementations;

@end

@implementation ILGSwizzler

- (NSString *)keyForSelector:(SEL)selector
                     onClass:(Class)class
{
    return [NSString stringWithFormat:@"%@.%@", NSStringFromClass(class), NSStringFromSelector(selector)];
}

- (void)replaceSelector:(SEL)selector
                onClass:(Class)targetClass
     withImplementation:(IMP)implementation
            usingGetter:(Method(*)(Class, SEL))getter
     andTrackingDictRef:(NSMutableDictionary **)trackingDictRef
{
    if (!*trackingDictRef) {
        *trackingDictRef = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    Method originalMethod = getter(targetClass, selector);
    IMP originalImplementation = method_getImplementation(originalMethod);
    NSString *key = [self keyForSelector:selector onClass:targetClass];
    if (!(*trackingDictRef)[key]) {
        (*trackingDictRef)[key] =[NSValue valueWithPointer:originalImplementation];
    }
    
    method_setImplementation(originalMethod, implementation);
}

- (void)replaceImplementationOfClassSelector:(SEL)selector
                                     onClass:(Class)targetClass
                          withImplementation:(IMP)implementation
{
    [self replaceSelector:selector
                  onClass:targetClass
       withImplementation:implementation
              usingGetter:class_getClassMethod
       andTrackingDictRef:&_originalClassMethodImplementations];
}

- (void)replaceImplementationOfInstanceSelector:(SEL)selector
                                        onClass:(Class)targetClass
                             withImplementation:(IMP)implementation
{
    [self replaceSelector:selector
                  onClass:targetClass
       withImplementation:implementation
              usingGetter:class_getInstanceMethod
       andTrackingDictRef:&_originalInstanceMethodImplementations];
}

- (void)replaceImplementationOfClassSelector:(SEL)selector
                                     onClass:(Class)targetClass
                 withImplementationFromClass:(Class)implementationClass
{
    Method replacementMethod = class_getClassMethod(implementationClass, selector);
    IMP replacementImplementation = method_getImplementation(replacementMethod);
    
    [self replaceImplementationOfClassSelector:selector
                                       onClass:targetClass
                            withImplementation:replacementImplementation];
}

- (void)replaceImplementationOfInstanceSelector:(SEL)selector
                                        onClass:(Class)targetClass
                    withImplementationFromClass:(Class)implementationClass
{
    Method replacementMethod = class_getInstanceMethod(implementationClass, selector);
    IMP replacementImplementation = method_getImplementation(replacementMethod);
    
    [self replaceImplementationOfInstanceSelector:selector
                                          onClass:targetClass
                               withImplementation:replacementImplementation];
}

- (void)replaceImplementationOfClassSelector:(SEL)selector
                                     onClass:(Class)targetClass
                                   withBlock:(id)implementationBlock
{
    [self replaceImplementationOfClassSelector:selector
                                       onClass:targetClass
                            withImplementation:imp_implementationWithBlock(implementationBlock)];
}

- (void)replaceImplementationOfInstanceSelector:(SEL)selector
                                        onClass:(Class)targetClass
                                      withBlock:(id)implementationBlock
{
    [self replaceImplementationOfInstanceSelector:selector
                                          onClass:targetClass
                               withImplementation:imp_implementationWithBlock(implementationBlock)];
}

- (void)done
{
    [[[self.originalClassMethodImplementations copy] autorelease] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSArray *parts = [(NSString *)key componentsSeparatedByString:@"."];
        if (parts.count != 2) {
            return;
        }
        Class class = NSClassFromString(parts[0]);
        SEL selector = NSSelectorFromString(parts[1]);
        Method method = class_getClassMethod(class, selector);
        IMP implementation = [(NSValue *)obj pointerValue];
        method_setImplementation(method, implementation);
        [self.originalClassMethodImplementations removeObjectForKey:key];
    }];
    [[[self.originalInstanceMethodImplementations copy] autorelease] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSArray *parts = [(NSString *)key componentsSeparatedByString:@"."];
        if (parts.count != 2) {
            return;
        }
        Class class = NSClassFromString(parts[0]);
        SEL selector = NSSelectorFromString(parts[1]);
        Method method = class_getInstanceMethod(class, selector);
        IMP implementation = [(NSValue *)obj pointerValue];
        method_setImplementation(method, implementation);
        [self.originalInstanceMethodImplementations removeObjectForKey:key];
    }];
}

- (void)dealloc
{
    [self done];
    self.originalClassMethodImplementations = nil;
    self.originalInstanceMethodImplementations = nil;
    [super dealloc];
}

@end
