//
//  TreeSitterTests.swift
//  TreeSitterTests
//
//  Created by Johannes Lund on 2016-05-03.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import XCTest
@testable import TreeSitter
import TreeSitterRuntime

func getExtent(_ string: String) -> Point {
    var result = Point.zero
    for c in string.characters {
        if (c == "\n") {
            result.row += 1
            result.column = 0
        } else {
            result.column += 1
        }
    }
    return result;
}

class TreeSitterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        print("\n\n")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        print("\n\n")
        super.tearDown()
    }
    
    func testLargeDocument() {
        let bundle = Bundle(for: TreeSitterTests.self)
        let url = bundle.url(forResource: "c", withExtension: "txt")!
        let string = try! String(contentsOf: url)
        let _ = Document(text: string, language: .c)
    }

    func testSmall() {
        let string = "//A" + "\n" + "var a = 2"
        let document = Document(text: string, language: .javascript)
        print(document.stringForNode(document.rootNode))
        XCTAssert(C.anon_sym_POUNDinclude.rawValue == 1)
        let a = Javascript(rawValue: document.rootNode.children[0].symbol)!
        let b = Javascript(rawValue: document.rootNode.children[1].symbol)!
        XCTAssertEqual(a, .sym_comment)
        XCTAssertEqual(b, .sym_trailing_var_declaration)
        
        var n = document.rootNode.children.first!
        
        print(Language.javascript.symbol.tokenType(for: &n, at: 0))
        
        let p = string.utf16.count
        let r = NSRange(location: p, length: 0)
        let replacement = "\n1"
        
        document.input.data.replaceCharactersInRange(r, replacementText: replacement)
        
        let edit = TSInputEdit(start_byte: UInt32(p) * 2, bytes_removed: 0, bytes_added: UInt32(replacement.utf16.count) * 2, start_point: Point(row: 1, column: 4), extent_removed: .zero, extent_added: Point(row: 1, column: 1))
        document.makeInputEdit(edit)
        let ranges = document.parseAndGetChangedRanges()
        print(ranges)
        print(String(data: document.input.data, encoding: .utf16))
        print(document.stringForNode(document.rootNode))
        print("new",document.rootNode.children.flatMap({C(rawValue: $0.symbol)}))
        
    }
    
}
