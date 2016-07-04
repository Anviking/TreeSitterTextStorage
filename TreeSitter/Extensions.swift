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

extension NSMutableData {
    func replaceCharactersInRange(_ range: NSRange, replacementText: String) {
        
        // NSMutable string has a padding of 2 and a char per 2 bytes (utf16)
        let padding = 2
        let byteRange = NSMakeRange(range.location * 2 + padding, range.length * 2)
        
        // Convert replacementText to utf16 bytes and remove padding
        var replacement = replacementText.data(using: String.Encoding.utf16)!
        replacement = replacement.subdata(in: NSMakeRange(padding, replacement.count - padding))
        
        
        // Strategy, 1) shift ENDSTRING to new location and 2) replace RANGE with REPLACEMENT
        
        // BEFORE: <------STRING-------><---RANGE---><--------ENDSTRING-------->
        // REPLACE:                     <---REPLACEMENT--->
        // FINAL:  <------STRING-------><---REPLACEMENT---><--------ENDSTRING-------->
        
        
        // ENDSTRING shifting delta
        let delta = replacement.count - byteRange.length
        
        let endStringStart = byteRange.location + byteRange.length + delta
        let endStringEnd = length + delta
        let endStringRange = NSMakeRange(endStringStart, endStringEnd - endStringStart)
        replaceBytes(in: endStringRange, withBytes: bytes + byteRange.location + byteRange.length)
        
        
        // Replace RANGE with REPLACEMENT
        replaceBytes(in: NSMakeRange(byteRange.location, replacement.count), withBytes: replacement.bytes)
        /*
         let str = NSString(data: self, encoding: NSUTF16StringEncoding)!
         let lineRange = str.lineRangeForRange(range)
         let line = str.substringWithRange(lineRange)
         print(str)
         */
    }
}
