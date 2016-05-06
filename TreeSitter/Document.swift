//
//  Document.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-05-06.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation
import TreeSitterRuntime

public struct Document {
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
    }
    
    func makeInputEdit(edit: TSInputEdit) {
        ts_document_edit(documentPointer, edit)
    }
    
    func stringForNode(node: Node) -> String {
        return String.fromCString(ts_node_string(node, documentPointer))!
    }
    
    
    
    
}