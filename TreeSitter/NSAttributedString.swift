//
//  NSAttributedString.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-09-24.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation

// FIXME: Avoid duplicate implementation


extension Node {
    fileprivate func write(to attributedString: NSMutableAttributedString, language: Language, theme: ColorTheme, font: UIFont, length: Int) {
        
        // FIXME: Don't pass -1 as location, make location optional instead
        var copy = self
        guard symbol != 0,
            let tokenType = language.symbol.tokenType(for: &copy, at: -1),
            language.metadata(for: symbol).structural,
            let color = theme[tokenType],
            self.start < UInt32(length) && self.end < UInt32(length) && self.range.count > 0
            else {
                children.forEach { $0.write(to: attributedString, language: language, theme: theme, font: font, length: length) }
                return
        }
        
        attributedString.setAttributes([
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: color
            ], range: NSRange(self.range))
    }
}

extension String {
    public func tokenize(as language: Language, theme: ColorTheme, font: UIFont) -> NSMutableAttributedString {
        let data = self.data(using: String.Encoding.utf16)!
        let document = Document(input: Input(data: data), language: language)
        let attributedString = NSMutableAttributedString(string: self, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.black])
        document.rootNode.write(to: attributedString, language: language, theme: theme, font: font, length: attributedString.length)
        return attributedString
    }
}
