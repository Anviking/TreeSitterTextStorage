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
    
    public static var languagePointer = ts_language_json()!
    
    public static func tokenType(for node: inout Node, at index: Int) -> TokenType? {
        guard let symbol = Json(rawValue: node.symbol) else { return nil }
        
        if symbol == Json.sym_pair {
            let firstString = node.children.first(where: {
                $0.symbol == Json.sym_string.rawValue
            })
            if let s = firstString, s.range.contains(UInt32(index)) {
                node = s
                return .text
            }
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
};
