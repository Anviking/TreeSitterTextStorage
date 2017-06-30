//
//  InputTests.swift
//  TreeSitterTests
//
//  Created by Johannes Lund on 2017-06-30.
//  Copyright © 2017 Johannes Lund. All rights reserved.
//

import XCTest
@testable import TreeSitter

class InputTests: XCTestCase {
    
    func testReplacement() {
        let str = "hi"
        var data = str.data(using: .utf16)!
        let range = NSRange(location: 1, length: 1)
        data.replaceCharactersInRange(range, replacementText: "ello")
        XCTAssertEqual(String(data: data, encoding: .utf16), "hello")
    }
    
    func testDelete() {
        let str = "hi"
        var data = str.data(using: .utf16)!
        let range = NSRange(location: 1, length: 1)
        data.replaceCharactersInRange(range, replacementText: "")
        XCTAssertEqual(String(data: data, encoding: .utf16), "h")
    }
    
    func testAdd() {
        let str = "hi"
        var data = str.data(using: .utf16)!
        let range = NSRange(location: 2, length: 0)
        data.replaceCharactersInRange(range, replacementText: "gh")
        XCTAssertEqual(String(data: data, encoding: .utf16), "high")
    }
    
}
