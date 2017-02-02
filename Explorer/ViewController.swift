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
import TreeSitterRuntime


class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    
    var document: OpaquePointer!
    
    var tokenizer: TextStorageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let url = Bundle.main.url(forResource: "c", withExtension: "txt")!
        let str = try! String(contentsOf: url)
        
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        let document = Document(text: str, language: .c)
        tokenizer = TextStorageDelegate(document: document)
        
        let textView = UITextView(frame: frame)
        textView.text = str
        textView.textStorage.delegate = tokenizer
        
        
        textView.backgroundColor = ColorTheme.dusk[.background]
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        self.view = textView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func visibleRangeOfTextView() -> NSRange {
        let bounds = textView.bounds;
        let start = textView.characterRangeAtPoint(bounds.origin)?.start ?? textView.beginningOfDocument
        let end = textView.characterRangeAtPoint(CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds)))!.end
        return NSMakeRange(textView.offsetFromPosition(textView.beginningOfDocument, toPosition: start), textView.offsetFromPosition(start, toPosition: end));
    }*/
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
