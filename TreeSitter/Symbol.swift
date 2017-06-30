//
//  Symbol.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-05-04.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation
import TreeSitterRuntime
import Languages

public protocol LanguageSymbolProtocol {
    init?(rawValue: UInt16)
    //var tokenType: TokenType? {get} // REMOVE THIS
    static var languagePointer: UnsafeMutablePointer<TSLanguage> { get }
    
    static func tokenType(for node: inout Node, at index: Int) -> TokenType?
}

extension Json: LanguageSymbolProtocol {
    public static var languagePointer: UnsafeMutablePointer<TSLanguage> {
        return tree_sitter_json()
    }
    
    public static func tokenType(for node: inout Node, at index: Int) -> TokenType? {
        guard let symbol = Json(rawValue: node.symbol) else { return nil }
        
        if symbol == Json.sym_pair {
            let firstString = node.children.first(where: {
                $0.symbol == Json.sym_string.rawValue
            })
//            if let s = firstString /*, s.range.contains(UInt32(index))*/ {
//                node = s
//                return .text
//            }
        }
        
        
        switch symbol {
        case .sym_string:
            return .string
        case .sym_false, .sym_true, .sym_null:
            return .keyword
        case .sym_number:
            return .number
        default:
            return nil
        }
    }
}

extension Cpp: LanguageSymbolProtocol {
    
    public static var languagePointer = tree_sitter_cpp()!
    
    public static func tokenType(for node: inout Node, at index: Int) -> TokenType? {
        guard let symbol = Cpp(rawValue: node.symbol) else { return nil }
        switch symbol {
        case .sym_comment:
            return .comment
        case .sym_string_literal, .sym_system_lib_string:
            return .string
        case .sym_auto, .sym_break_statement:
            return .keyword
        case .sym_number_literal:
            return .number
        case .sym_identifier:
            return .projectMethodNames
        default:
            return nil
        }
    }
}

