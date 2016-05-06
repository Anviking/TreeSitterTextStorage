//
//  Language.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-05-06.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation
import TreeSitterRuntime
import Language

public struct Language {
    let languagePointer: UnsafePointer<TSLanguage>
    
    public init(pointer: UnsafePointer<TSLanguage>) {
        self.languagePointer = pointer
    }
    
    public static let C = Language(pointer: ts_language_c())
}