//
//  JSON.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-07-07.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation
import Language
extension Json: LanguageSymbolProtocol {
    
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
};
