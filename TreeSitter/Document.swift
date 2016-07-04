//
//  Document.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-05-06.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation
import TreeSitterRuntime

public class Document {
    let documentPointer: OpaquePointer
    var language: Language
    var input: Input
    
    
    public init(input: Input, language: Language) {
        self.documentPointer = ts_document_make()
        self.language = language
        self.input = input
        ts_document_set_language(documentPointer, language.languagePointer)
        ts_document_set_input(documentPointer, asTSInput(&self.input))
        parse()
    }
    
    var rootNode: Node {
        return ts_document_root_node(documentPointer)
    }
    
    
    public func parse() {
        ts_document_parse(documentPointer)
        print(ts_document_parse_count(documentPointer))
    }
    
    func makeInputEdit(_ edit: TSInputEdit) {
        ts_document_edit(documentPointer, edit)
    }
    
    func stringForNode(_ node: Node) -> String {
        return String(cString: ts_node_string(node, documentPointer))
    }
    
    func nodeRepresentation(_ node: Node, range: Range<Int>, documentString: String) -> AttributedString {
        let start = node.start - range.lowerBound
        let nodeEnd = node.end - range.lowerBound
        let windowEnd = range.upperBound
        let end = min(nodeEnd, windowEnd)
        if start > end {
            return AttributedString()
        }
        
        let localNodeRange = start ..< end
        
        let window = documentString.substring(with: documentString.startIndex ..< documentString.characters.index(documentString.startIndex, offsetBy: range.upperBound))
        let characters = Array(window.characters)
        var empty = Array(repeating: " ", count: range.count)
        
        for (index, _) in empty.enumerated() {
            if localNodeRange.contains(index) {
                empty[index] = String(characters[index])
            }
        }
        
        let string = empty.joined(separator: "")
        
        let attr = NSMutableAttributedString(string: string.replacingOccurrences(of: "\n", with: "¶") + "\n", attributes: node.attributes())
        
        for child in node.children {
            attr.append(nodeRepresentation(child, range: range, documentString: documentString))
        }
        
        return attr
    }
    
    
}






extension Node {
    func color() -> UIColor {
        return ((C.Symbol(rawValue: symbol)?.tokenType).flatMap { ColorTheme.default[$0] }) ?? UIColor.black()
    }
    
    private func attributes() -> [String: AnyObject] {
        return [
            NSForegroundColorAttributeName: color(),
            NSFontAttributeName: UIFont(name: "Menlo", size: 12)!
        ]
    }
}

extension NSRange {
    func intersection(_ range: Range<Int>) -> CountableRange<Int> {
        let start = max(location, range.lowerBound)
        let end = min(location + length, range.upperBound)
        return start ..< end
    }
}

