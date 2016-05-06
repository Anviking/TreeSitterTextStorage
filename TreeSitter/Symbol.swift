//
//  Symbol.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-05-04.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation

public protocol Symbol {
    init?(rawValue: UInt16)
    var tokenType: TokenType? {get} // REMOVE THIS
    var isOpaque: Bool { get }
}

extension Symbol {
    public func colorForTheme(theme: ColorTheme) -> UIColor {
        return theme[tokenType!]!
    }
}
