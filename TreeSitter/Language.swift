//
//  Language.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-05-06.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation
import TreeSitterRuntime

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
            return Ruby.self
            //return C.self
        case .ruby:
            return Ruby.self
        case .javascript:
            return Javascript.self
        case .json:
            fatalError()
        case .cpp:
            return Cpp.self
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
