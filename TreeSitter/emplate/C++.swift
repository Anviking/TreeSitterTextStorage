//
//  C++.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-07-06.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation
import Language

extension Cpp: LanguageSymbolProtocol {
    
    public static var languagePointer = ts_language_cpp()!
    
    public static func tokenType(for node: inout Node, at index: UInt32) -> TokenType? {
        guard let symbol = Cpp(rawValue: node.symbol) else { return nil }
        switch symbol {
        case .sym_comment:
            return .comment
        case .sym_string_literal, .sym_system_lib_string:
            return .string
        case .anon_sym_auto, .sym_break_statement:
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
