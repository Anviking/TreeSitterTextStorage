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

extension UnsafeMutablePointer where Memory: IntegerType {
    func replaceCharactersInRange(range: NSRange, replacementText: String) {
        let replacementLength = replacementText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        let delta = replacementLength - range.length
        
        memmove(self + range.location + delta, self + range.location, 7000)
        memcpy(self + range.location, replacementText, replacementLength)
    }
}


class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    var string = UnsafeMutablePointer<CChar>.alloc(76163)
    var index: UInt16 = 201
    var symbol: Symbol?
    var previousRoot: TSNode?

    var document: COpaquePointer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.autocapitalizationType = .None
        textView.autocorrectionType = .No
        

        // Do any additional setup after loading the view.
        let url = NSBundle.mainBundle().URLForResource("test", withExtension: "txt")!
        let str = try! String(contentsOfURL: url)
        
        let attributedString = NSMutableAttributedString(string: str, attributes: [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSBackgroundColorAttributeName: ColorTheme.Dusk[.Background]!,
            NSFontAttributeName: UIFont(name: "Menlo", size: 10)!
            ])
        
        strcpy(string, str)
        
        textView.delegate = self
        textView.attributedText = attributedString
        document = ts_document_make();
        ts_document_set_input_string(document, string);
        ts_document_set_language(document, ts_language_c());
        ts_document_parse(document);
        tokenize()
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
        tokenize()
    }
    
    func tokenize() {
        
        //self.textView.textStorage.setAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSBackgroundColorAttributeName: ColorTheme.Dusk[.Background]!], range: NSMakeRange(0, self.textView.textStorage.length))
        let test = NSAttributedString(attributedString: self.textView.textStorage)
        let root_node = ts_document_root_node(document);
        
        func traverseNode(node: TSNode) {
            if ts_node_has_changes(node) {
                print("CHANGES")
            }

            for i in 0 ..< ts_node_named_child_count(node) {
                let child = ts_node_named_child(node, i)
                if let symbol = C.Symbol(rawValue: ts_node_symbol(child)) {
                    
                        let start = ts_node_start_byte(child)
                        let end = ts_node_end_byte(child)
                        self.textView.textStorage.addAttribute(NSForegroundColorAttributeName, value: ColorTheme.Dusk[symbol.tokenType]!, range: NSMakeRange(start, end - start))
                }
                
                traverseNode(child)
                
            }
        }
        
        
        
        traverseNode(root_node)
    }
    
    func clearNode(node: TSNode) {
        let start = ts_node_start_byte(node)
        let end = ts_node_end_byte(node)
        textView.textStorage.setAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSBackgroundColorAttributeName: ColorTheme.Dusk[.Background]!], range: NSMakeRange(start, end - start))
    }
    
    func tokenize(index index: Int, overrideColor: UIColor? = nil) {
        print("--- tokenizing ---")
        let root_node = ts_document_root_node(document);
        var node = ts_node_descendant_for_range(root_node, index, index + 1)
        var array = [TSNode]()
        while !ts_node_eq(node, root_node) {
            array.append(node)
            node = ts_node_parent(node)
        }
        
        let _ = array.last.map(clearNode)
        
        for node in array.reverse() {
            if ts_node_has_changes(node) { print("CHANGES") }
            if let symbol = C.Symbol(rawValue: ts_node_symbol(node)) {
                let start = ts_node_start_byte(node)
                let end = ts_node_end_byte(node)
                let color = overrideColor ?? ColorTheme.Dusk[symbol.tokenType]!
                self.textView.textStorage.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(start, end - start))
            }
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        let edit = TSInputEdit(position: range.location, chars_inserted: text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding), chars_removed: range.length)
        
        string.replaceCharactersInRange(range, replacementText: text)
        ts_document_edit(document, edit)
        tokenize(index: range.location, overrideColor: UIColor.purpleColor())
        ts_document_parse(document)
        //let s = NSString(string: textView.text).stringByReplacingCharactersInRange(range, withString: text)
        //memcpy(UnsafeMutablePointer(s.cStringUsingEncoding(NSUTF8StringEncoding)!), string, 7000)
        
        //print(String.fromCString(string))
        //print(edit)
        //ts_document_invalidate(document)
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        tokenize(index: textView.selectedRange.location)
    }
    
    func visibleRangeOfTextView() -> NSRange {
    let bounds = textView.bounds;
    let start = textView.characterRangeAtPoint(bounds.origin)!.start
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
