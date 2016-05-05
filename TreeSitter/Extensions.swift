//
//  Extensions.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-05-05.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation

extension NSRange {
    func intersectsRange(range: NSRange) -> Bool {
        if location > range.location + range.length {
            return false
        }
        if location > location + length {
            return false
        }
        return true
    }
}