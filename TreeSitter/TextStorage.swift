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
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var data: NSMutableData
    public var document: Document
    
    public override var string: String {
        return String(data: data, encoding: NSUTF16StringEncoding)!
    }
    
    public override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
    
        /*
        let node = document.rootNode.children.first!.children.first!
        print(node.children.count)
        for child in node.children {
            print(child)
        }
        print(document.stringForNode(node))
         */
        
        var lastNode: Node!
        for node in TraverseInRangeGenerator(node: document.rootNode, index: location, document: document) {
        // for node in document.rootNode.children {
            lastNode = node
            guard let symbol = C.Symbol(rawValue: node.symbol), color = ColorTheme.Dusk[symbol.tokenType] where symbol.tokenType != .Text else { continue }
            guard node.start < length && node.end < length && node.range.length > 0  else { continue }
            range.memory = node.range
            return attributesForColor(color)
        }
        
        if range != nil, let lastNode = lastNode {
            range.memory = lastNode.range
        }
 
        return attributesForColor(textColor)
    }
    
    private var textColor: UIColor {
        return ColorTheme.Dusk[.Text]!
    }
    
    public override func replaceCharactersInRange(range: NSRange, withString str: String) {
        let edit = TSInputEdit(position: range.location, chars_inserted: str.characters.count, chars_removed: range.length)
        document.makeInputEdit(edit)
        data.replaceCharactersInRange(range, replacementText: str)
    }
    
    public override func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
        print("Can't set attributes \(attrs), range: \(range)")
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


