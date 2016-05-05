//
//  ViewController.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-05-03.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import UIKit
import TreeSitter
import TreeSitterRuntime
import Language

struct Input {
    var data: NSData
    var position: Int
    var length: Int
}

extension NSRange {
    func intersectsRange(range: NSRange) -> Bool
    {
        if location > range.location + range.length {
            return false
        }
        if location > location + length {
            return false
        }
        return true
    }
}

extension UnsafeMutablePointer where Memory: IntegerType {
    func replaceCharactersInRange(range: NSRange, replacementText: String) {
        let replacementLength = replacementText.lengthOfBytesUsingEncoding(NSUTF16StringEncoding)
        let delta = replacementLength - range.length
        
        memmove(self + range.location + delta, self + range.location, 7000)
        memcpy(self + range.location, replacementText, replacementLength)
    }
}

extension NSMutableData {
    func replaceCharactersInRange(range: NSRange, replacementText: String) {
        
        // NSMutable string has a padding of 2 and a char per 2 bytes (utf16)
        let padding = 2
        let byteRange = NSMakeRange(range.location * 2 + padding, range.length * 2)
        
        // Convert replacementText to utf16 bytes and remove padding
        var replacement = replacementText.dataUsingEncoding(NSUTF16StringEncoding)!
        replacement = replacement.subdataWithRange(NSMakeRange(padding, replacement.length - padding))
        
        
        // Strategy, 1) shift ENDSTRING to new location and 2) replace RANGE with REPLACEMENT
        
        // BEFORE: <------STRING-------><---RANGE---><--------ENDSTRING-------->
        // REPLACE:                     <---REPLACEMENT--->
        // FINAL:  <------STRING-------><---REPLACEMENT---><--------ENDSTRING-------->
        
        
        // ENDSTRING shifting delta
        let delta = replacement.length - byteRange.length
        
        let endStringStart = byteRange.location + byteRange.length + delta
        let endStringEnd = length + delta
        let endStringRange = NSMakeRange(endStringStart, endStringEnd - endStringStart)
        replaceBytesInRange(endStringRange, withBytes: bytes + byteRange.location + byteRange.length)
        
        
        // Replace RANGE with REPLACEMENT
        replaceBytesInRange(NSMakeRange(byteRange.location, replacement.length), withBytes: replacement.bytes)
        /*
         let str = NSString(data: self, encoding: NSUTF16StringEncoding)!
         let lineRange = str.lineRangeForRange(range)
         let line = str.substringWithRange(lineRange)
         print(str)
         */
    }
}


class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    
    var data: NSMutableData!
    var index: UInt16 = 201
    var input: Input!
    var symbol: Symbol?
    var previousRoot: TSNode?
    
    var document: COpaquePointer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(ts_language_test())
        
        textView.autocapitalizationType = .None
        textView.autocorrectionType = .No
        
        
        // Do any additional setup after loading the view.
        let url = NSBundle.mainBundle().URLForResource("test", withExtension: "txt")!
        let str = try! String(contentsOfURL: url)
        
        let attributedString = NSMutableAttributedString(string: str, attributes: [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSBackgroundColorAttributeName: ColorTheme.Dusk[.Background]!,
            NSFontAttributeName: UIFont(name: "Menlo", size: 12)!
            ])
        
        
        
        data = str.dataUsingEncoding(NSUTF16StringEncoding)!.mutableCopy() as! NSMutableData
        
        textView.delegate = self
        textView.attributedText = attributedString
        document = ts_document_make();
        
        self.input = Input(data: data, position: 0, length: data.length)
        let input = TSInput(payload: &self.input, read_fn: { payload, read in
            let pointer = UnsafeMutablePointer<Input>(payload)
            var input = pointer.memory
            if (input.position >= input.length) {
                read.memory = 0;
                return UnsafePointer(strdup(""))
            }
            let previousPosition = input.position;
            input.position = input.length;
            read.memory = input.position - previousPosition
            pointer.memory = input
            return UnsafePointer(input.data.bytes + 2) + previousPosition;
            
            }, seek_fn: { payload, character, byte in
                
                let pointer = UnsafeMutablePointer<Input>(payload)
                var input = pointer.memory
                input.position = byte;
                pointer.memory = input
                return byte < input.length ? 1 : 0
            }, encoding: TSInputEncodingUTF16)
        ts_document_set_input(document, input);
        ts_document_set_language(document, ts_language_c());
        ts_document_parse(document);
        tokenize(ts_document_root_node(document))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func textFieldDidChange(sender: UITextField) {
        if sender.text!.containsString("+") {
            sender.text = (Int(sender.text!.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "+")))! + 1).description
        }
        
        if sender.text!.containsString("-") {
            sender.text = (Int(sender.text!.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "-")))! - 1).description
        }
        
        guard let text = sender.text else { return }
        guard let index = UInt16(text) else { return }
        
        self.index = index
        tokenize(ts_document_root_node(document))
    }
    
    func clearNode(node: TSNode) {
        let start = ts_node_start_char(node)
        let end = ts_node_end_char(node)
        textView.textStorage.setAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSBackgroundColorAttributeName: ColorTheme.Dusk[.Background]!], range: NSMakeRange(start, end - start))
    }
    
    func tokenize2(range: NSRange) {
        
        
        let length = self.textView.textStorage.length
        let root = ts_document_root_node(document)
        
        let closure = { (node: TSNode) in
            //print(String.fromCString(ts_node_name(node, self.document)))
            if node.hasChanges {
                print("CHANGED")
            }
            if true {
                if let symbol = C.Symbol(rawValue: ts_node_symbol(node)) {
                    let start = node.start
                    let end = node.end
                    let range = NSMakeRange(start, end - start)
                    if start < length && end < length && range.length > 0 {
                        let color = ColorTheme.Dusk[.String]!
                        self.textView.textStorage.setAttributes([
                            NSForegroundColorAttributeName: color,
                            NSBackgroundColorAttributeName: ColorTheme.Dusk[.Background]!,
                            NSFontAttributeName: UIFont(name: "Menlo", size: 12)!
                            ], range: range)
                    }
                }
            }
        }
        
        let closure2 = { (node: TSNode) in
            if let symbol = C.Symbol(rawValue: ts_node_symbol(node)) {
                let start = node.start
                let end = node.end
                let range = NSMakeRange(start, end - start)
                if start < length && end < length && range.length > 0 {
                    let color = ColorTheme.Dusk[symbol.tokenType]!
                    self.textView.textStorage.setAttributes([
                        NSForegroundColorAttributeName: color,
                        NSBackgroundColorAttributeName: ColorTheme.Dusk[.Background]!,
                        NSFontAttributeName: UIFont(name: "Menlo", size: 12)!
                        ], range: range)
                }
            }
        }
        
        
        //defer { previousRoot = root }
        let node = ts_node_descendant_for_range(root, range.location, NSMaxRange(range))
        //print(node.stringInDocument(document))
        node.forEachUpwards(root, block: closure)
        if !ts_node_eq(node, root) {
            node.forEach(closure)
        }
        //root.forEach(inRange: range, block: closure2)
        
    }
    
    func tokenize(node: Node) {
        let length = self.textView.textStorage.length
        print(node.stringInDocument(document))
        guard let symbol = C.Symbol(rawValue: node.symbol) else { return }
        if node.start < length && node.end < length && node.range.length > 0 {
            if symbol == C.Symbol.sym_declaration {
                if let index = node.children.indexOf({ C.Symbol(rawValue: $0.symbol)! == .sym_identifier }) {
                    let type = node.children[index]
                    let color = ColorTheme.Dusk[.OtherClassNames]!
                    self.textView.textStorage.setAttributes([
                        NSForegroundColorAttributeName: color,
                        NSBackgroundColorAttributeName: ColorTheme.Dusk[.Background]!,
                        NSFontAttributeName: UIFont(name: "Menlo", size: 12)!
                        ], range: type.range)
                    
                    for (i, child) in node.children.enumerate() where i != index {
                        tokenize(child)
                    }
                    return
                }
                
            }
            
            let color = ColorTheme.Dusk[symbol.tokenType]!
            
            self.textView.textStorage.setAttributes([
                NSForegroundColorAttributeName: color,
                NSBackgroundColorAttributeName: ColorTheme.Dusk[.Background]!,
                NSFontAttributeName: UIFont(name: "Menlo", size: 12)!
                ], range: node.range)
        }
        
        node.children.forEach(tokenize)
    }
    
    
    var recentRange: NSRange?
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        let edit = TSInputEdit(position: range.location, chars_inserted: text.characters.count, chars_removed: range.length)
        data.replaceCharactersInRange(range, replacementText: text)
        recentRange = NSMakeRange(range.location, max(range.length, 0) + text.characters.count)
        ts_document_edit(document, edit)
        ts_document_parse(document)
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        let date = NSDate()
        textView.textStorage.beginEditing()
        
        let range = visibleRangeOfTextView()
        //if let range = recentRange {
        tokenize2(range)
        //}
        
        
        textView.textStorage.endEditing()
        print("Tokenizing took: \(abs(date.timeIntervalSinceNow * 1000)) ms")
    }
    
    func visibleRangeOfTextView() -> NSRange {
        let bounds = textView.bounds;
        let start = textView.characterRangeAtPoint(bounds.origin)?.start ?? textView.beginningOfDocument
        let end = textView.characterRangeAtPoint(CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds)))!.end
        return NSMakeRange(textView.offsetFromPosition(textView.beginningOfDocument, toPosition: start), textView.offsetFromPosition(start, toPosition: end));
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
