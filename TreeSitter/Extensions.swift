//
//  Extensions.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-05-05.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation

extension NSRange {
    func intersectsRange(_ range: NSRange) -> Bool {
        if location > range.location + range.length {
            return false
        }
        if location > location + length {
            return false
        }
        return true
    }
    
    func containsIndex(_ index: Int) -> Bool {
        let range = location ..< (location + length)
        return range.contains(index)
    }
}

extension Data {
    mutating func replaceCharactersInRange(_ range: NSRange, replacementText: String) {
        
        // NSMutable string has a padding of 2 and a char per 2 bytes (utf16)
        let padding = 2
        let byteRange = NSMakeRange(range.location * 2 + padding, range.length * 2).toRange()!
        
        // Convert replacementText to utf16 bytes and remove padding
        let r = replacementText.data(using: String.Encoding.utf16)!
        let replacement = r.subdata(in: padding ..< r.endIndex)
        
        print(replacement.count)
        
        
        // Strategy, 1) shift ENDSTRING to new location and 2) replace RANGE with REPLACEMENT
        
        // BEFORE: <------STRING-------><---RANGE---><--------TAIL-------->
        // REPLACE:                     <---REPLACEMENT--->
        // FINAL:  <------STRING-------><---REPLACEMENT---><--------TAIL-------->
        
        
        // ENDSTRING shifting delta
        let delta = replacement.count - byteRange.count
        
        let endStringStart = byteRange.upperBound + delta
        let endStringEnd = count + delta
        
        let endstring = subdata(in: byteRange.upperBound ..< endIndex)
        
        if delta > 0 {
            append(Data(bytes: Array(repeating: 0, count: delta)))
        }
        
        replaceBytes(in: endStringStart ..< self.endIndex, with: endstring)
        
        
        // Replace RANGE with REPLACEMENT
        replaceBytes(in: byteRange.lowerBound ..< byteRange.lowerBound + replacement.count, with: replacement)
    }
}
