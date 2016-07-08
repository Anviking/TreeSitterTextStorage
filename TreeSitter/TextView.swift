//
//  TextView.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-07-05.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation

public class TextView: UITextView {
    
    private var _textStorage: TextStorage
    
    var theme: ColorTheme
    var language: Language
    
    public init(frame: CGRect, theme: ColorTheme, language: Language, text: String) {
        
        self.theme = theme
        self.language = language
        
        let textStorage = TextStorage(string: text, theme: theme, language: language)
        self._textStorage = textStorage
        /*
        for node in textStorage.document.rootNode.children {
            for node in node.children where node.symbol == C.sym_function_declarator.rawValue {
                let str = (text as NSString).substring(with: node.range)
                print("*** \(str)")

            }
        }
        */
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer()
        layoutManager.allowsNonContiguousLayout = true
        textContainer.widthTracksTextView = true
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        
        
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = ColorTheme.dusk[.background]
        autocapitalizationType = .none
        autocorrectionType = .no

    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
