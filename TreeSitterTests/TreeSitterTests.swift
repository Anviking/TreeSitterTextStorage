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
import Language

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
    
    func testExample() {
        let bundle = Bundle(for: TreeSitterTests.self)
        let url = bundle.urlForResource("test", withExtension: "txt")!
        let string = try! String(contentsOf: url)
        
        
        let attributedString = NSMutableAttributedString(string: string, attributes: [
            NSForegroundColorAttributeName: UIColor.white(),
            NSFontAttributeName: UIFont(name: "Menlo", size: 14)!
            ])
        
        let document = ts_document_make();
        ts_document_set_language(document, ts_language_c());
        let data = string.data(using: .utf16)!
        var input = Input(data: data)
        ts_document_set_input(document, asTSInput(&input))
        
        
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
                
                let symbol = C.Symbol(rawValue: ts_node_symbol(child))!
                print(symbol)
                
                if let token = symbol.tokenType where token != .text {
                    attributedString.addAttributes([NSForegroundColorAttributeName: ColorTheme.dusk[token]!], range: NSMakeRange(start, end - start))
                }
                
                
                //print("\(stars) \(name): \(text)")
                traverseNode(node: child, depth: depth + 1)
                
            }
        }
        
        traverseNode(node: root_node)
        
        //assert(strcmp(ts_node_name(root_node, document), "expression") != 0)
        //assert(ts_node_named_child_count(root_node) == 1)
        
        //let sum_node = ts_node_named_child(root_node, 0)
        //assert(strcmp(ts_node_name(sum_node, document), "sum") != 0)
        //assert(ts_node_named_child_count(sum_node) == 2);
        
        //let product_node = ts_node_child(ts_node_named_child(sum_node, 1), 0);
        //assert(strcmp(ts_node_name(product_node, document), "product") != 0)
        //assert(ts_node_named_child_count(product_node) == 2);
        
        let a = ts_node_string(root_node, document)
        
        let result = String(cString: a!)
        print("Syntax tree: ", result);
        ts_document_free(document);
    }
    
    func testRuby() {
        //let bundle = NSBundle(forClass: TreeSitterTests.self)
        //let url = bundle.URLForResource("testRuby", withExtension: "txt")!
        var string = UnsafeMutablePointer<CChar>(allocatingCapacity: 1000)
        let s = "a = \"abcde\""
        strcpy(string, s)
        
        let attributedString = NSMutableAttributedString(string: s, attributes: [
            NSForegroundColorAttributeName: UIColor.white(),
            NSFontAttributeName: UIFont(name: "Menlo", size: 10)!
            ])
        
        let document = ts_document_make();
        ts_document_set_language(document, ts_language_ruby());
        ts_document_set_input_string(document, string);
        
        
        ts_document_parse(document);
        
        let root_node = ts_document_root_node(document);
        
        
        var nodes = [TSNode]()
        func traverseNode(node: TSNode, depth: Int = 0) {
            for i in 0 ..< ts_node_child_count(node) {
                let child = ts_node_child(node, i)
                let start = ts_node_start_byte(child)
                let end = ts_node_end_byte(child)
                
                if let symbol = Ruby.Symbol(rawValue: ts_node_symbol(child)) where symbol.tokenType == .text{
                    attributedString.addAttributes([NSForegroundColorAttributeName: ColorTheme.dusk[symbol.tokenType!]!], range: NSMakeRange(start, end - start))
                }
                
                if ts_node_symbol(child) == Ruby.Symbol.sym_string.rawValue {
                    nodes.append(child)
                }
                
                //print("\(stars) \(name): \(text)")
                traverseNode(node: child, depth: depth + 1)
                
            }
        }
        
        traverseNode(node: root_node)
        
        //assert(strcmp(ts_node_name(root_node, document), "expression") != 0)
        //assert(ts_node_named_child_count(root_node) == 1)
        
        //let sum_node = ts_node_named_child(root_node, 0)
        //assert(strcmp(ts_node_name(sum_node, document), "sum") != 0)
        //assert(ts_node_named_child_count(sum_node) == 2);
        
        //let product_node = ts_node_child(ts_node_named_child(sum_node, 1), 0);
        //assert(strcmp(ts_node_name(product_node, document), "product") != 0)
        //assert(ts_node_named_child_count(product_node) == 2);
        
        
    
        
        let str = nodes[0]
        
        
        

        
        
        strcpy(string, "ab = \"abcdef\"")
        ts_document_edit(document, TSInputEdit(position: 1, chars_inserted: 1, chars_removed: 0))
        ts_document_edit(document, TSInputEdit(position: 10, chars_inserted: 1, chars_removed: 0))
        //ts_document_edit(document, TSInputEdit(position: 12, chars_inserted: 0, chars_removed: 1))
        ts_document_parse(document)
        
        
        
        let root = ts_document_root_node(document)
        
        let a = ts_node_descendant_for_range(root, 4, 11)
        print(ts_node_has_changes(str))
        let b = ts_node_child(a, 2)
        
        let start = ts_node_start_byte(b)
        let end = ts_node_end_byte(b)
        
        let st = String(cString: string)
        print(st.substring(with: st.index(st.startIndex, offsetBy: start) ..< st.index(st.startIndex, offsetBy: end) ))
        
        print(ts_node_has_changes(b))
        
        
        let result = String(cString: ts_node_string(b, document))
        
        print("Syntax tree: ", result);
        ts_document_free(document);
    }
    
}
