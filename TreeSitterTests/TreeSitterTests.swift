//
//  TreeSitterTests.swift
//  TreeSitterTests
//
//  Created by Johannes Lund on 2017-06-29.
//  Copyright © 2017 Johannes Lund. All rights reserved.
//

import XCTest
@testable import TreeSitter

class TreeSitterTests: XCTestCase {
    
    let font = UIFont(name: "Menlo", size: 18)!
    
    func testJSON() {
        let json = """
        {"key": 42}
        """
        let attr = json.tokenize(as: .json, theme: .default, font: font)
        print(attr)
    }
    
    func testCpp() {
        let code = """
        // hello world
        """
        let data = code.data(using: String.Encoding.utf16)!
        let document = Document(input: Input(data: data), language: .cpp)
        let attributedString = NSMutableAttributedString(string: code, attributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.black])
        document.rootNode.write(to: attributedString, language: .cpp, theme: .default, font: font, length: attributedString.length)
        print(document.rootNode.stringInDocument(document.documentPointer))
    }
    
}
