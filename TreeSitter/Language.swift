//
//  Language.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-05-06.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation
import TreeSitterRuntime

struct Tokenizer<Token> {
    func attributes(for: Token) -> [String: Any] {
        return [:]
    }
}

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
        case .json:
            return Json.self
        case .cpp:
            return Cpp.self
        default: fatalError()
        }
    }
    
    
    func metadata(for symbol: UInt16) -> TSSymbolMetadata {
        guard (0 ..< languagePointer.pointee.symbol_count).contains(UInt32(Int(symbol))) else {
            fatalError("wrong symbol \(symbol)")
        }
        let p = languagePointer.pointee.symbol_metadata + Int(symbol)
        return p.pointee
    }
    
}
