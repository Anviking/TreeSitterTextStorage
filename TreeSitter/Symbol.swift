//
//  Symbol.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-05-04.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation
import Language

public protocol LanguageSymbolProtocol {
    init?(rawValue: UInt16)
    //var tokenType: TokenType? {get} // REMOVE THIS
    static var languagePointer: UnsafeMutablePointer<TSLanguage> { get }
    
    static func tokenType(for node: inout Node, at index: Int) -> TokenType?
}

/*
extension LanguageSymbolProtocol {
    public func colorForTheme(_ theme: ColorTheme) -> UIColor {
        return theme[tokenType!]!
    }
}
*/
