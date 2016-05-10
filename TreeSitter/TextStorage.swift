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
    
    public override init(string: String) {
        let data = string.dataUsingEncoding(NSUTF16StringEncoding)!.mutableCopy() as! NSMutableData
        self.data = data
        self.document = Document(input: Input(data: data), language: Language.C)
        super.init()
        _length = length
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var data: NSMutableData
    public var document: Document
    
    private var _length = 0
    
    public override var string: String {
        return String(data: data, encoding: NSUTF16StringEncoding)!
    }
    
    var cache: [Int: (range: NSRange, color: UIColor)] = [:]
    
    public override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
        
        var lastNode = document.rootNode
        for node in TraverseInRangeGenerator(node: document.rootNode, index: location, document: document) {
            lastNode = node
            guard let symbol = C.Symbol(rawValue: node.symbol) where symbol.isOpaque else { continue }
            guard let tokenType = symbol.tokenType, color = ColorTheme.Dusk[tokenType] else { continue }
            guard node.start < _length && node.end < length && node.range.length > 0  else { continue }
            if range != nil {
                range.memory = node.range
            }
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
        
        range.memory = r
        return attributesForColor(textColor)
    }
    
    private var textColor: UIColor {
        return ColorTheme.Dusk[.Text]!
    }
    
    public override func replaceCharactersInRange(range: NSRange, withString str: String) {
        let date = NSDate()
        let edit = TSInputEdit(position: range.location, chars_inserted: str.characters.count, chars_removed: range.length)
        let delta = str.characters.count - range.length
        cache = [:]
        _length += delta
        let actions: NSTextStorageEditActions = [.EditedCharacters, .EditedAttributes]
        delegate?.textStorage?(self, willProcessEditing: actions, range: range, changeInLength: delta)
        document.makeInputEdit(edit)
        self.edited(actions, range: range, changeInLength: delta)
        data.replaceCharactersInRange(range, replacementText: str)
        document.parse()
        delegate?.textStorage?(self, didProcessEditing: actions, range: range, changeInLength: delta)
        print("Tokenizing took: \(abs(date.timeIntervalSinceNow * 1000)) ms")
    }
    
    public override func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
        //print("Can't set attributes \(attrs), range: \(range)")
    }
    
    public override var fixesAttributesLazily: Bool {
        return true
    }
}

// MARK: Helpers


private func attributesForColor(color: UIColor) -> [String: AnyObject] {
    return [
        NSForegroundColorAttributeName: color,
        NSBackgroundColorAttributeName: ColorTheme.Dusk[.Background]!,
        NSFontAttributeName: UIFont(name: "Menlo", size: 12)!
    ]
}


