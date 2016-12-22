//
//  C.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-05-04.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation
import Language

extension C: LanguageSymbolProtocol {
    
    public static var languagePointer = ts_language_c()!
    
    public static func tokenType(for node: inout Node, at index: UInt32) -> TokenType? {
        guard let symbol = C(rawValue: node.symbol) else { return nil }
        
        
        if symbol == C.sym_identifier && node.parent.symbol == C.sym_function_declarator.rawValue {
            return .projectMethodNames
        }
        
        switch symbol {
        case .sym_string_literal, .sym_system_lib_string:
            return .string
        case .sym_char_literal:
            return .character
        case .anon_sym_POUNDinclude, .sym_preproc_ifdef, .sym_preproc_directive, .sym_preproc_def:
            return .preprocessor
        case .sym_comment:
            return .comment
        case .sym_number_literal:
            return .number
        case .anon_sym_return, .anon_sym_while, .anon_sym_static, .anon_sym_const, .anon_sym_volatile, .sym_function_specifier, .anon_sym_if, .anon_sym_else, .anon_sym_enum, .anon_sym_struct, .anon_sym_case, .anon_sym_for, .anon_sym_auto, .anon_sym_default, .anon_sym_typedef, .anon_sym_goto:
            return .keyword
        case .sym_type_name, .anon_sym_sizeof:
            return .otherMethodNames
            
        default:
            return nil // Important to return nil to continue search in nested nodes
        }
    }
    
    public var isOpaque: Bool {
        return true
    }
    
}


