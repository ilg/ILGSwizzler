//
//  ILGSwizzler.swift
//  ILGSwizzler
//
//  Created by Isaac Greenspan on 10/2/20.
//

import Foundation

public class ILGSwizzler {
    private struct Key: Hashable {
        static func == (lhs: Self, rhs: Self) -> Bool {
            NSStringFromClass(lhs.cls) == NSStringFromClass(rhs.cls)
                && NSStringFromSelector(lhs.selector) == NSStringFromSelector(rhs.selector)
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(NSStringFromClass(cls))
            hasher.combine(NSStringFromSelector(selector))
        }
        
        let cls: AnyClass
        let selector: Selector
    }
    
    private var originalClassMethodImplementations: [Key: IMP] = [:]
    private var originalInstanceMethodImplementations: [Key: IMP] = [:]
    
    private func key(for selector: Selector, on cls: AnyClass) -> Key {
        Key(cls: cls, selector: selector)
    }
    
    private func replace(selector: Selector,
                         on targetClass: AnyClass,
                         with implementation: IMP,
                         using getter: (AnyClass?, Selector) -> Method?,
                         setter: (Key, IMP) -> Void) {
        guard let originalMethod = getter(targetClass, selector) else { return }
        let originalImplementation = method_getImplementation(originalMethod)
        let key = self.key(for: selector, on: targetClass)
        setter(key, originalImplementation)
        method_setImplementation(originalMethod, implementation)
    }
    
    private func replaceClassImplementation(of selector: Selector,
                                            on targetClass: AnyClass,
                                            with implementation: IMP) {
        replace(selector: selector,
                on: targetClass,
                with: implementation,
                using: class_getClassMethod) { key, imp in
                    if originalClassMethodImplementations[key] == nil {
                        originalClassMethodImplementations[key] = imp
                    }
        }
    }
    
    private func replaceInstanceImplementation(of selector: Selector,
                                               on targetClass: AnyClass,
                                               with implementation: IMP) {
        replace(selector: selector,
                on: targetClass,
                with: implementation,
                using: class_getInstanceMethod) { key, imp in
                    if originalInstanceMethodImplementations[key] == nil {
                        originalInstanceMethodImplementations[key] = imp
                    }
        }
    }
    
    public func replaceImplementation(ofClassSelector selector: Selector,
                                      on targetClass: AnyClass,
                                      withImplementationFrom implementationClass: AnyClass) {
        guard let replacementMethod = class_getClassMethod(implementationClass, selector) else { return }
        let replacementImplementation = method_getImplementation(replacementMethod)
        replaceClassImplementation(of: selector,
                                   on: targetClass,
                                   with: replacementImplementation)
    }
    
    public func replaceImplementation(ofInstanceSelector selector: Selector,
                                      on targetClass: AnyClass,
                                      withImplementationFrom implementationClass: AnyClass) {
        guard let replacementMethod = class_getInstanceMethod(implementationClass, selector) else { return }
        let replacementImplementation = method_getImplementation(replacementMethod)
        replaceInstanceImplementation(of: selector,
                                      on: targetClass,
                                      with: replacementImplementation)
    }
    
    public func replaceImplementation(ofClassSelector selector: Selector,
                                      on targetClass: AnyClass,
                                      withBlock implementationBlock: Any) {
        replaceClassImplementation(of: selector,
                                   on: targetClass,
                                   with: imp_implementationWithBlock(implementationBlock))
    }
    
    public func replaceImplementation(ofInstanceSelector selector: Selector,
                                      on targetClass: AnyClass,
                                      withBlock implementationBlock: Any) {
        replaceInstanceImplementation(of: selector,
                                      on: targetClass,
                                      with: imp_implementationWithBlock(implementationBlock))
    }
    
    public func done() {
        for (key, implementation) in originalClassMethodImplementations {
            guard let method = class_getClassMethod(key.cls, key.selector) else { continue }
            method_setImplementation(method, implementation)
        }
        originalClassMethodImplementations = [:]
        
        for (key, implementation) in originalInstanceMethodImplementations {
            guard let method = class_getInstanceMethod(key.cls, key.selector) else { continue }
            method_setImplementation(method, implementation)
        }
        originalInstanceMethodImplementations = [:]
    }
    
    public init() {}
    
    deinit {
        done()
    }
}
