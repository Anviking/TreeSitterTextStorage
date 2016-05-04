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
        
        memmove(self + range.location + delta, self + range.location, 80)
        memcpy(self + range.location, replacementText, replacementLength)
    }
}

public func tokenize2(document: COpaquePointer, textStorage: NSTextStorage, force: Bool = false, tokenizeClosure: Ruby.Symbol -> UIColor?) {
    
    
    let root_node = ts_document_root_node(document);

    if !force && !ts_node_has_changes(root_node) {
        return
    }
    
    func traverseNode(node: TSNode, depth: Int = 0) {
        for i in 0 ..< ts_node_child_count(node) {
            let child = ts_node_child(node, i)
            
            if !force && !ts_node_has_changes(child) {
                continue
            }
            //let text = string.substringWithRange(string.startIndex.advancedBy(start) ..< string.startIndex.advancedBy(end))
            //let name = String.fromCString(ts_node_name(child, document))!
            //let stars = Array(count: depth * 3, repeatedValue: " ").joinWithSeparator("")
            
    
            if let symbol = Ruby.Symbol(rawValue: ts_node_symbol(child)) {
            if let color = tokenizeClosure(symbol) {
                let start = ts_node_start_byte(child)
                let end = ts_node_end_byte(child)
                textStorage.addAttributes([NSForegroundColorAttributeName: color], range: NSMakeRange(start, end - start))
            }
            }
            
            traverseNode(child, depth: depth + 1)
            
        }
    }
    
    traverseNode(root_node)
}


class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    var string = UnsafeMutablePointer<CChar>.alloc(76163)
    var index: UInt16 = 0
    var symbol: Symbol?
    var document: COpaquePointer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.autocapitalizationType = .None
        textView.autocorrectionType = .No
        

        // Do any additional setup after loading the view.
        let url = NSBundle.mainBundle().URLForResource("testRuby", withExtension: "txt")!
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
        ts_document_set_language(document, ts_language_ruby());
        ts_document_parse(document);
        tokenize(true)
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
        tokenize(true)
        
    }
    
    func tokenize(force: Bool = false) {
        if let targetSymbol = Ruby.Symbol(rawValue: index) {
            self.title = "\(targetSymbol)"
            tokenize2(document, textStorage: textView.textStorage, force: force) { symbol in
                if targetSymbol == symbol {
                    return ColorTheme.Default[.Keyword]!
                } else {
                    return nil
                }
            }
        }

    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        let edit = TSInputEdit(position: range.location, chars_inserted: text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding), chars_removed: range.length)
        string.replaceCharactersInRange(range, replacementText: text)
        print(UnsafePointer<[CChar]>(string))
        ts_document_edit(document, edit)
        let a = ts_node_string(ts_document_root_node(document), document)
        ts_document_parse(document)
        tokenize()
        print(a)
        return true
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
