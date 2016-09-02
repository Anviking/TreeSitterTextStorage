//
//  JSON.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-07-07.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation
import Language
public enum JSON: UInt16, LanguageSymbolProtocol {
    
    public static var languagePointer = ts_language_javascript()!
    
    public var tokenType: TokenType? {
        switch self {
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
    
    case sym__value = 2
    case sym_object
    case sym_pair
    case sym_array
    case aux_sym_object_repeat1
    case aux_sym_array_repeat1
    case anon_sym_LBRACE
    case anon_sym_COMMA
    case anon_sym_RBRACE
    case anon_sym_COLON
    case anon_sym_LBRACK
    case anon_sym_RBRACK
    case sym_string
    case sym_number
    case sym_true
    case sym_false
    case sym_null
};
