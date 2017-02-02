//
//  Javascript.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-07-07.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation
import TreeSitterRuntime
import Languages

extension Javascript: LanguageSymbolProtocol {
    
    public static var languagePointer = tree_sitter_javascript()!
    
    public static func tokenType(for node: inout Node, at index: Int) -> TokenType? {
        guard let symbol = Javascript(rawValue: node.symbol) else { return nil }
        switch symbol {
        case .sym_string:
            return .string
        case .sym_comment:
            return .comment
        case .sym_number:
            return .number
        case .anon_sym_return, .anon_sym_while, .anon_sym_static, .anon_sym_const, .anon_sym_if, .anon_sym_else, .sym_class, .anon_sym_function, .anon_sym_var, .anon_sym_EQ_GT, .anon_sym_async, .anon_sym_await, .anon_sym_export:
            return .keyword
        case .sym_identifier:
            switch Javascript(rawValue: node.parent.symbol) {
            case .some(.sym_var_declaration):
                return .projectMethodNames
            default:
                return .text
            }
        case .sym_member_access:
            return .otherMethodNames
        default:
            return nil // Important to return nil to continue search in nested nodes
        }
    }
}
