//
//  ILGSwizzlerTests.swift
//  ILGSwizzlerTests
//
//  Created by Isaac Greenspan on 10/2/20.
//  Copyright © 2020 2718.us. All rights reserved.
//

import XCTest
import ILGSwizzler

private class Target: NSObject {
    @objc dynamic class func returnsZero() -> Int { 0 }
    @objc dynamic func returnsZero() -> Int { 0 }
}

private class Source: NSObject {
    @objc dynamic class func returnsZero() -> Int { NSNotFound }
    @objc dynamic func returnsZero() -> Int { NSNotFound }
}

class ILGSwizzlerTests: XCTestCase {
    func testInstanceSwizzleFromClass() {
        // Check default behavior.
        XCTAssertEqual(Target.returnsZero(), 0, "Pre-swizzle class implementation failed to return 0.")
        do {
            let target = Target()
            XCTAssertEqual(target.returnsZero(), 0, "Pre-swizzle default instance implementation failed to return 0.")
        }
        
        // Do the swizzling.
        do {
            let swizzler = ILGSwizzler()
            swizzler.replaceInstanceImplementation(of: #selector(Target.returnsZero),
                                                   on: Target.self,
                                                   withImplementationFrom: Source.self)
            
            // Check swizzled behavior.
            let target = Target()
            XCTAssertEqual(target.returnsZero(), NSNotFound, "Swizzled replacement instance implementation failed to return NSNotFound.")
            XCTAssertEqual(Target.returnsZero(), 0, "Instance swizzling caused class implementation to fail to return 0.")
            
            // Un-swizzle.
            swizzler.done()
        }
        
        // Re-check default behavior.
        do {
            let target = Target()
            XCTAssertEqual(target.returnsZero(), 0, "Post-swizzle-un-swizzle instance implementation failed to return 0.")
        }
        XCTAssertEqual(Target.returnsZero(), 0, "Instance swizzling caused class implementation to fail to return 0 (after un-swizzle).")
    }
    
    func testClassSwizzleFromClass() {
        // Check default behavior.
        XCTAssertEqual(Target.returnsZero(), 0, "Pre-swizzle class implementation failed to return 0.")
        do {
            let target = Target()
            XCTAssertEqual(target.returnsZero(), 0, "Pre-swizzle default instance implementation failed to return 0.")
        }
        
        // Do the swizzling.
        do {
            let swizzler = ILGSwizzler()
            swizzler.replaceClassImplementation(of: #selector(Target.returnsZero),
                                                on: Target.self,
                                                withImplementationFrom: Source.self)
            
            // Check swizzled behavior.
            let target = Target()
            XCTAssertEqual(target.returnsZero(), 0, "Class swizzling caused instance implementation to fail to return 0.")
            XCTAssertEqual(Target.returnsZero(), NSNotFound, "Swizzled replacement class implementation failed to return NSNotFound.")
            
            // Un-swizzle.
            swizzler.done()
        }
        
        // Re-check default behavior.
        do {
            let target = Target()
            XCTAssertEqual(target.returnsZero(), 0, "Class swizzling caused instance implementation to fail to return 0 (after un-swizzle).")
            XCTAssertEqual(Target.returnsZero(), 0, "Post-swizzle-un-swizzle class implementation failed to return 0.")
        }
    }
    
    func testInstanceSwizzleFromBlock() {
        // Check default behavior.
        XCTAssertEqual(Target.returnsZero(), 0, "Pre-swizzle class implementation failed to return 0.")
        do {
            let target = Target()
            XCTAssertEqual(target.returnsZero(), 0, "Pre-swizzle default instance implementation failed to return 0.")
        }
        
        // Do the swizzling.
        do {
            let swizzler = ILGSwizzler()
            swizzler.replaceInstanceImplementation(of: #selector(Target.returnsZero),
                                                   on: Target.self,
                                                   with: { _ in NSNotFound } as @convention(block) (Any) -> Int)
            
            // Check swizzled behavior.
            let target = Target()
            XCTAssertEqual(target.returnsZero(), NSNotFound, "Swizzled replacement instance implementation failed to return NSNotFound.")
            XCTAssertEqual(Target.returnsZero(), 0, "Instance swizzling caused class implementation to fail to return 0.")
            
            // Un-swizzle.
            swizzler.done()
        }
        
        // Re-check default behavior.
        let target = Target()
        XCTAssertEqual(target.returnsZero(), 0, "Post-swizzle-un-swizzle instance implementation failed to return 0.")
        XCTAssertEqual(Target.returnsZero(), 0, "Instance swizzling caused class implementation to fail to return 0 (after un-swizzle).")
    }
    
    func testClassSwizzleFromBlock() {
        // Check default behavior.
        XCTAssertEqual(Target.returnsZero(), 0, "Pre-swizzle class implementation failed to return 0.")
        do {
            let target = Target()
            XCTAssertEqual(target.returnsZero(), 0, "Pre-swizzle default instance implementation failed to return 0.")
        }
        
        // Do the swizzling.
        do {
            let swizzler = ILGSwizzler()
            swizzler.replaceClassImplementation(of: #selector(Target.returnsZero),
                                                on: Target.self,
                                                with: { _ in NSNotFound } as @convention(block) (Any) -> Int)
            
            // Check swizzled behavior.
            let target = Target()
            XCTAssertEqual(target.returnsZero(), 0, "Class swizzling caused instance implementation to fail to return 0.")
            XCTAssertEqual(Target.returnsZero(), NSNotFound, "Swizzled replacement class implementation failed to return NSNotFound.")
            
            // Un-swizzle.
            swizzler.done()
        }
        
        // Re-check default behavior.
        do {
            let target = Target()
            XCTAssertEqual(target.returnsZero(), 0, "Class swizzling caused instance implementation to fail to return 0 (after un-swizzle).")
            XCTAssertEqual(Target.returnsZero(), 0, "Post-swizzle-un-swizzle class implementation failed to return 0.")
        }
    }
    
    func testDoubleClassSwizzleFromBlock() {
        // Check default behavior.
        XCTAssertEqual(Target.returnsZero(), 0, "Pre-swizzle default class implementation failed to return 0.")
        
        // Do the first swizzling.
        do {
            let swizzler = ILGSwizzler()
            swizzler.replaceClassImplementation(of: #selector(Target.returnsZero),
                                                on: Target.self,
                                                with: { _ in NSNotFound } as @convention(block) (Any) -> Int)
            
            // Check swizzled behavior.
            XCTAssertEqual(Target.returnsZero(), NSNotFound, "Swizzled (first) replacement class implementation failed to return NSNotFound.")
            
            // Do the second swizzling.
            swizzler.replaceClassImplementation(of: #selector(Target.returnsZero),
                                                on: Target.self,
                                                with: { _ in 42 } as @convention(block) (Any) -> Int)
            
            // Check swizzled behavior.
            XCTAssertEqual(Target.returnsZero(), 42, "Swizzled (second) replacement class implementation failed to return 42.")
            
            // Un-swizzle.
            swizzler.done()
        }
        
        // Re-check default behavior.
        XCTAssertEqual(Target.returnsZero(), 0, "Post-swizzle-un-swizzle class implementation failed to return 0.")
    }
    
    func testDoubleInstanceSwizzleFromBlock() {
        // Check default behavior.
        do {
            let target = Target()
            XCTAssertEqual(target.returnsZero(), 0, "Pre-swizzle default instance implementation failed to return 0.")
        }
        
        // Do the first swizzling.
        do {
            let swizzler = ILGSwizzler()
            swizzler.replaceInstanceImplementation(of: #selector(Target.returnsZero),
                                                   on: Target.self,
                                                   with: { _ in NSNotFound } as @convention(block) (Any) -> Int)
            
            // Check swizzled behavior.
            do {
                let target = Target()
                XCTAssertEqual(target.returnsZero(), NSNotFound, "Swizzled (first) replacement instance implementation failed to return NSNotFound.")
            }
            
            // Do the second swizzling.
            swizzler.replaceInstanceImplementation(of: #selector(Target.returnsZero),
                                                   on: Target.self,
                                                   with: { _ in 42 } as @convention(block) (Any) -> Int)
            
            // Check swizzled behavior.
            do {
                let target = Target()
                XCTAssertEqual(target.returnsZero(), 42, "Swizzled (second) replacement instance implementation failed to return 42.")
            }
            
            // Un-swizzle.
            swizzler.done()
        }
        
        // Re-check default behavior.
        do {
            let target = Target()
            XCTAssertEqual(target.returnsZero(), 0, "Post-swizzle-un-swizzle instance implementation failed to return 0.")
        }
    }
}
