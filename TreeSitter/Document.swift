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
    let documentPointer: COpaquePointer
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
    
    func makeInputEdit(edit: TSInputEdit) {
        ts_document_edit(documentPointer, edit)
    }
    
    func stringForNode(node: Node) -> String {
        return String.fromCString(ts_node_string(node, documentPointer))!
    }
    
    func nodeRepresentation(node: Node, range: Range<Int>, documentString: String) -> NSAttributedString {
        let start = node.start - range.startIndex
        let nodeEnd = node.end - range.startIndex
        let windowEnd = range.endIndex
        let end = min(nodeEnd, windowEnd)
        if start > end {
            return NSAttributedString()
        }
        
        let localNodeRange = start ..< end
        
        let window = documentString.substringWithRange(documentString.startIndex ..< documentString.startIndex.advancedBy(range.endIndex))
        let characters = Array(window.characters)
        var empty = Array(count: range.count, repeatedValue: " ")
        
        for (index, _) in empty.enumerate() {
            if localNodeRange.contains(index) {
                empty[index] = String(characters[index])
            }
        }
        
        let string = empty.joinWithSeparator("")
        
        let attr = NSMutableAttributedString(string: string.stringByReplacingOccurrencesOfString("\n", withString: "¶") + "\n", attributes: node.attributes())
        
        for child in node.children {
            attr.appendAttributedString(nodeRepresentation(child, range: range, documentString: documentString))
        }
        
        return attr
    }
    
    
}






extension Node {
    func color() -> UIColor {
        return ((C.Symbol(rawValue: symbol)?.tokenType).flatMap { ColorTheme.Default[$0] }) ?? UIColor.blackColor()
    }
    
    private func attributes() -> [String: AnyObject] {
        return [
            NSForegroundColorAttributeName: color(),
            NSFontAttributeName: UIFont(name: "Menlo", size: 12)!
        ]
    }
}

extension NSRange {
    func intersection(range: Range<Int>) -> Range<Int> {
        let start = max(location, range.startIndex)
        let end = min(location + length, range.endIndex)
        return start ..< end
    }
}

