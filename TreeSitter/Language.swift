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


private let _c = ts_language_c()!
private let _ruby = ts_language_ruby()!

public enum Language {
    case c
    case ruby
    case other(languagePointer: UnsafeMutablePointer<TSLanguage>, colorizer: (UInt16) -> TokenType)
    
    var languagePointer: UnsafeMutablePointer<TSLanguage> {
        switch self {
        case .c:
            return _c
        case .ruby:
            return _ruby
        case .other(let pointer, _ ):
            return pointer
        }
    }
    
    func tokenType(for i: UInt16) -> TokenType? {
        switch self {
        case .c:
            return C(rawValue: i)?.tokenType
        case .ruby:
            return Ruby(rawValue: i)?.tokenType
        case .other(_, let colorizer):
            return colorizer(i)
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
