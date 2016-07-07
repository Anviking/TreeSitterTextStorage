//
//  Language.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-05-06.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation
import TreeSitterRuntime
import Language

public enum Language {
    case c
    case ruby
    case cpp
    case json
    case javascript
    //    case other(languagePointer: UnsafeMutablePointer<TSLanguage>, colorizer: (UInt16) -> TokenType)
    
    var languagePointer: UnsafeMutablePointer<TSLanguage> {
        return symbol.languagePointer
    }
    
    var symbol: LanguageSymbolProtocol.Type {
        switch self {
        case .c:
            return C.self
        case .ruby:
            return Ruby.self
        case .javascript:
            return JavaScript.self
        case .json:
            return JSON.self
        case .cpp:
            return Cpp.self
        }
    }
    
    func tokenType(for node: inout Node, index: Int) -> TokenType? {
        switch self {
        case .json:
            guard let symbol = JSON(rawValue: node.symbol) else { return nil }
            if symbol == JSON.sym_pair {
                let firstString = node.children.first(where: {
                    $0.symbol == JSON.sym_string.rawValue
                })
                if let s = firstString where s.range.containsIndex(index) {
                    node = s
                    return .otherProperties
                }
            }
            fallthrough
        case .c:
            guard let symbol = C(rawValue: node.symbol) else { return nil }
            if symbol == C.sym_function_specifier {
                let firstString = node.children.first(where: {
                    $0.symbol == C.sym_identifier.rawValue
                })
                if let s = firstString where s.range.containsIndex(index) {
                    node = s
                    return .text
                }
            }
            fallthrough
        default:
            return symbol.init(rawValue: node.symbol)?.tokenType
        }
    }
    
    func metadata(for symbol: UInt16) -> TSSymbolMetadata {
        guard (2 ..< 2 + languagePointer.pointee.symbol_count).contains(Int(symbol)) else {
            fatalError("wrong symbol \(symbol)")
        }
        let p = languagePointer.pointee.symbol_metadata + Int(symbol - 2)
        return p.pointee
    }
    
}
