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
    
    var document: OpaquePointer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let url = Bundle.main().urlForResource("test", withExtension: "txt")!
        let str = try! String(contentsOf: url)
             
        let textStorage = TextStorage(string: str, theme: .civicModified, language: .c)
        
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer()
        textContainer.widthTracksTextView = true
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        let textView = UITextView(frame: frame, textContainer: textContainer)
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
