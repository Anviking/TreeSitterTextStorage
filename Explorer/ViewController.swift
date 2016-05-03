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

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var string: String!
    var index: UInt16 = 0
    var symbol: Symbol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = NSBundle.mainBundle().URLForResource("test", withExtension: "txt")!
        string = try! String(contentsOfURL: url)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func textFieldDidChange(sender: UITextField) {
        guard let text = sender.text else { return }
        guard let index = UInt16(text) else { return }
        if let targetSymbol = Symbol(rawValue: index) {
            self.title = "\(targetSymbol)"
            let attributedString = tokenize(string) { symbol in
                if targetSymbol == symbol {
                    return ColorTheme.Default[.Keyword]!
                } else {
                    return nil
                }
            }
            self.textView.attributedText = attributedString
        }
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
