//
//  TextStorage.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-05-06.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation
import Language
import TreeSitterRuntime

/* Note for subclassing NSTextStorage: NSTextStorage is a semi-abstract subclass of NSMutableAttributedString. It implements change management (beginEditing/endEditing), verification of attributes, delegate handling, and layout management notification. The one aspect it does not implement is the actual attributed string storage --- this is left up to the subclassers, which need to override the two NSMutableAttributedString primitives in addition to two NSAttributedString primitives:
 
 - (NSString *)string;
 - (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range;
 
 - (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str;
 - (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range;
 
 These primitives should perform the change then call edited:range:changeInLength: to get everything else to happen.
 */

public class TextStorage: NSTextStorage {
    
    // MARK: Initialization
    
    var theme: ColorTheme
    
    public init(string: String, theme: ColorTheme, language: Language) {
        
        let data = string.data(using: String.Encoding.utf16)!
        self.theme = theme
        self.document = Document(input: Input(data: data), language: language)
        self.cache = Array(repeating: nil, count: data.count)
        super.init()
        _length = length
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var document: Document
    
    private var _length = 0
    
    public override var string: String {
        return String(data: document.input.data, encoding: String.Encoding.utf16)!
    }

    
    var cache: [(C.Symbol?, NSRange)?]
    
    public override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [String : AnyObject] {
        
        if let cached = cache[location] {
            range?.pointee = cached.1
            let color = cached.0.flatMap { $0.tokenType }.flatMap { ColorTheme.civicModified[$0] }
            return attributesForColor(color ?? textColor)
        }
        
        var lastNode = document.rootNode
        for node in TraverseInRangeGenerator(node: document.rootNode, index: location, document: document) {
            lastNode = node
            guard let symbol = C.Symbol(rawValue: node.symbol) where symbol.structural else { continue }
            guard let tokenType = symbol.tokenType, color = ColorTheme.civicModified[tokenType] else { continue }
            guard node.start < _length && node.end < length && node.range.length > 0  else { continue }
            
            range?.pointee = node.range
            cache[location] = (symbol, node.range)
            return attributesForColor(color)
        }
        
        guard range != nil else {
            return attributesForColor(textColor)
        }
        
        
        let r: NSRange
        if let endNode = lastNode.children.filter({ $0.start > location }).first {
            r = NSMakeRange(location, endNode.start - location)
        } else if ts_node_eq(document.rootNode, lastNode) {
            r = NSRange(location: lastNode.end, length: _length-lastNode.end)
        } else {
            r = lastNode.range
        }
        
        range?.pointee = r
        cache[location] = (nil, r)
        return attributesForColor(textColor)
    }
    
    private var textColor: UIColor {
        return ColorTheme.civicModified[.text]!
    }
    
    public override func replaceCharacters(in range: NSRange, with str: String) {
        let date = Date()
        
        let edit = TSInputEdit(position: range.location, chars_inserted: str.characters.count, chars_removed: range.length)
        let delta = str.characters.count - range.length
        _length += delta
        cache = Array(repeating: nil, count: _length + 10) // to be safe O.O
        
        let actions: NSTextStorageEditActions = [.editedCharacters, .editedAttributes]
        delegate?.textStorage?(self, willProcessEditing: actions, range: range, changeInLength: delta)
        document.makeInputEdit(edit)
        document.input.data.replaceCharactersInRange(range, replacementText: str)
        self.edited(actions, range: range, changeInLength: delta)
        document.parse()
        delegate?.textStorage?(self, didProcessEditing: actions, range: range, changeInLength: delta)
        print("Tokenizing took: \(abs(date.timeIntervalSinceNow * 1000)) ms")
    }
    
    public override func setAttributes(_ attrs: [String : AnyObject]?, range: NSRange) {
        //print("Can't set attributes \(attrs), range: \(range)")
    }
    
    public override var fixesAttributesLazily: Bool {
        return true
    }
}

// MARK: Helpers

private let font = UIFont(name: "Menlo", size: 14)!

private func attributesForColor(_ color: UIColor) -> [String: AnyObject] {
    return [
        NSForegroundColorAttributeName: color,
        NSFontAttributeName: font
    ]
}


