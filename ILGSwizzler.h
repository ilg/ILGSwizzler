//
//  ILGSwizzler.h
//
//  Created by Isaac Greenspan on 1/23/13.
//
//

#import <Foundation/Foundation.h>

/**
 *  Class to facilitate replacing the implementation of class and/or instance methods with methods of the same name on 
 *  another class or with blocks, as well as facilitate undoing this swizzling.  Intended for use in unit testing.
 */
@interface ILGSwizzler : NSObject

/**
 *  Replace the implementation of a class method on one class with the corresponding method's implementation from 
 *  another class.
 *
 *  @param selector            The selector to replace
 *  @param targetClass         The class on which to replace it
 *  @param implementationClass The class from which to get the replacement implementation
 */
- (void)replaceImplementationOfClassSelector:(SEL)selector
                                     onClass:(Class)targetClass
                 withImplementationFromClass:(Class)implementationClass;

/**
 *  Replace the implementation of an instance method on one class with the corresponding method's implementation from
 *  another class.
 *
 *  @param selector            The selector to replace
 *  @param targetClass         The class on which to replace it
 *  @param implementationClass The class from which to get the replacement implementation
 */
- (void)replaceImplementationOfInstanceSelector:(SEL)selector
                                        onClass:(Class)targetClass
                    withImplementationFromClass:(Class)implementationClass;

/**
 *  Replace the implementation of a class method on a given class with a block.
 *
 *  @param selector            The selector to replace
 *  @param targetClass         The class on which to replace it
 *  @param implementationBlock The block to use as the replacement implementation
 */
- (void)replaceImplementationOfClassSelector:(SEL)selector
                                     onClass:(Class)targetClass
                                   withBlock:(id)implementationBlock;

/**
 *  Replace the implementation of an instance method on a given class with a block.
 *
 *  @param selector            The selector to replace
 *  @param targetClass         The class on which to replace it
 *  @param implementationBlock The block to use as the replacement implementation
 */
- (void)replaceImplementationOfInstanceSelector:(SEL)selector
                                        onClass:(Class)targetClass
                                      withBlock:(id)implementationBlock;

/**
 *  Undo any method implementation replacement.
 */
- (void)done;

@end
