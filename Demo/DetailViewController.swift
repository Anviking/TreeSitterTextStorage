//
//  DetailViewController.swift
//  Demo
//
//  Created by Johannes Lund on 2017-06-29.
//  Copyright © 2017 Johannes Lund. All rights reserved.
//

import UIKit
import TreeSitter

class DetailViewController: UIViewController {

    var sample: Sample!
    var delegate: !
    var textView: UITextView = {
        let document = Document(text: str, language: .c)
        tokenizer = TextStorageDelegate(document: document)
        let textView = UITextView(frame: frame)
        textView.text = str
        textView.textStorage.delegate = tokenizer
        
        
        textView.backgroundColor = ColorTheme.dusk[.background]
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        self.view = textView
    }()

    override func loadView() {
        let textView
        self.view = textView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

