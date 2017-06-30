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

    var sample: Sample? {
        didSet {
            guard let sample = sample else {
                textView.text = ""
                return
                
            }
            let document = Document(text: sample.code, language: sample.language)
            delegate = TextStorageDelegate(document: document)
            
            textView.text = sample.code
            textView.textStorage.delegate = delegate
        }
    }
    var delegate: TextStorageDelegate!
    var textView: UITextView = UITextView(frame: .zero)

    override func loadView() {
        
        textView.backgroundColor = ColorTheme.dusk[.background]
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        
        self.view = textView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

