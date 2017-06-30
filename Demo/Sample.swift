//
//  Sample.swift
//  Demo
//
//  Created by Johannes Lund on 2017-06-30.
//  Copyright © 2017 Johannes Lund. All rights reserved.
//

import Foundation
import TreeSitter

/// Code sample
struct Sample: CustomStringConvertible {
    let code: String
    let language: Language
    
    init(code: String, language: Language) {
        self.code = code
        self.language = language
    }
    
    /// File path in bundle
    init?(filename: String, language: Language) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: ".txt") else {
            return nil
        }
        
        guard let string = try? String(contentsOf: url) else {
            return nil
        }
        
        self.code = string
        self.language = language
    }
    
    var formattedBytes: String {
        let formatter = ByteCountFormatter()
        return formatter.string(fromByteCount: Int64(code.lengthOfBytes(using: .utf8)))
    }
    
    var description: String {
        let lines = code.components(separatedBy: "\n").count
        return "\(language) (\(lines) lines)"
    }
    
}
