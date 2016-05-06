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


class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    
    var data: NSMutableData!
    var index: UInt16 = 201
    var symbol: Symbol?
    var previousRoot: TSNode?
    
    var document: COpaquePointer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(ts_language_test())
        
        
        
        // Do any additional setup after loading the view.
        let url = NSBundle.mainBundle().URLForResource("test", withExtension: "txt")!
        let str = try! String(contentsOfURL: url)
             
        let textStorage = TextStorage(string: str)
        
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer()
        textContainer.widthTracksTextView = true
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        let textView = UITextView(frame: frame, textContainer: textContainer)
        textView.autocapitalizationType = .None
        textView.autocorrectionType = .No
        
        self.view = textView
        
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
    }
    
    func textViewDidChange(textView: UITextView) {
        let date = NSDate()
        textView.textStorage.beginEditing()
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
