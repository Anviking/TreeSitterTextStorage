//
//  TextStorageHelper.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-11-07.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation
import TreeSitterRuntime

public class TextStorageDelegate: NSObject, NSTextStorageDelegate {
    let document: Document
    
    public init(document: Document) {
        self.document = document
    }
    
    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        
        let date = Date()
        
        let str = textStorage.string
        let range = editedRange
        
        let start = Point(row: 0, column: 0)
        
        let edit = TSInputEdit(start_byte: UInt32(range.location) * 2, bytes_removed: UInt32(range.length) * 2, bytes_added: UInt32(str.characters.count) * 2, start_point: start, extent_removed: .zero, extent_added: Point(row: 0, column:  UInt32(str.characters.count) * 2))
        document.input.data.replaceCharactersInRange(range, replacementText: str)
        
        document.makeInputEdit(edit)
        let ranges = document.parseAndGetChangedRanges()
        
        
        print("Tokenizing took: \(abs(date.timeIntervalSinceNow * 1000)) ms")

    }
    
    func parse() {
        let changedIndices = IndexSet()
        let language = document.language
        let theme = ColorTheme.default
        
        for node in document.rootNode.children {
            let range = Int(node.start) ... Int(node.end)
            guard changedIndices.contains(integersIn: range) else { continue }
            
            guard node.symbol != 0 else { continue }
            var node = node
            guard let tokenType = language.symbol.tokenType(for: &node, at: node.start) else { continue }
            guard language.metadata(for: node.symbol).structural else {
                continue
            }
            
            guard let color = theme[tokenType] else { continue }
        }
    }
}
