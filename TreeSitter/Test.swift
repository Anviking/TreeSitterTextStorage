//
//  Test.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-05-03.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation
import TreeSitterRuntime
import Language

public func tokenize(string: String, tokenize: Symbol -> UIColor?) -> NSAttributedString {
    
    let attributedString = NSMutableAttributedString(string: string, attributes: [
        NSForegroundColorAttributeName: UIColor.whiteColor(),
         NSBackgroundColorAttributeName: ColorTheme.Dusk[.Background]!,
         NSFontAttributeName: UIFont(name: "Menlo", size: 14)!
        ])
    
    let document = ts_document_make();
    ts_document_set_language(document, ts_language_c());
    ts_document_set_input_string(document, string);
    
    
    ts_document_parse(document);
    
    let root_node = ts_document_root_node(document);
    
    print(ts_node_child_count(root_node))
    func traverseNode(node: TSNode, depth: Int = 0) {
        for i in 0 ..< ts_node_child_count(node) {
            let child = ts_node_child(node, i)
            let start = ts_node_start_byte(child)
            let end = ts_node_end_byte(child)
            
            //let text = string.substringWithRange(string.startIndex.advancedBy(start) ..< string.startIndex.advancedBy(end))
            //let name = String.fromCString(ts_node_name(child, document))!
            //let stars = Array(count: depth * 3, repeatedValue: " ").joinWithSeparator("")
            
            print(string)
            let symbol = Ruby.Symbol(rawValue: ts_node_symbol(child))!
            print(symbol)
            
            if symbol.tokenType != .Text {
                attributedString.addAttributes([NSForegroundColorAttributeName: ColorTheme.Dusk[symbol.tokenType]!], range: NSMakeRange(start, end - start))
            }
            
            
            //print("\(stars) \(name): \(text)")
            traverseNode(child, depth: depth + 1)
            
        }
    }
    
    traverseNode(root_node)
    return attributedString
}
