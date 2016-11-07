//
//  Ruby.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-05-04.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation
import Language

extension Ruby: LanguageSymbolProtocol {
    
    // FIXME
    public static var languagePointer = ts_language_javascript()!
    
    public static func tokenType(for node: inout Node, at index: Int) -> TokenType? {
        guard let symbol = Ruby(rawValue: node.symbol) else { return nil }
        switch symbol {
        case .sym_string, .sym__quoted_string, .sym__literal:
            return .string
        case .sym_integer, .sym_float:
            return .number
        case .sym_comment, .sym_begin_statement:
            return .comment
        case .anon_sym_do, .anon_sym_if, .anon_sym_else, .anon_sym_def, .sym_nil, .anon_sym_until, .anon_sym_end, .anon_sym_class, .anon_sym_module:
            return .keyword
        case .sym_function_call, .sym__function_name, .sym_method_declaration:
            return TokenType.projectMethodNames
        default:
            return nil
        }
    }
    
    public var isOpaque: Bool {
        return true
    }
}
