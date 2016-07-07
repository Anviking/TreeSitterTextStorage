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
    
    func tokenType(for i: UInt16) -> TokenType? {
        return symbol.init(rawValue: i)?.tokenType
    }
    
    func metadata(for symbol: UInt16) -> TSSymbolMetadata {
        guard (2 ..< 2 + languagePointer.pointee.symbol_count).contains(Int(symbol)) else {
            fatalError("wrong symbol \(symbol)")
        }
        let p = languagePointer.pointee.symbol_metadata + Int(symbol - 2)
        return p.pointee
    }
    
}
