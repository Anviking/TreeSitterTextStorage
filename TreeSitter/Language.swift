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
    case other(languagePointer: UnsafeMutablePointer<TSLanguage>)
    
    var languagePointer: UnsafeMutablePointer<TSLanguage> {
        switch self {
        case .c:
            return _c
        case .ruby:
            return _ruby
        case .other(let pointer):
            return pointer
        }
    }
    
}
