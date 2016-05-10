//
//  Input.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-05-06.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation
import TreeSitterRuntime

public class Input {
    var data: NSData
    var position: Int
    var length: Int {
        return data.length - 2
    }
    
    public init(data: NSData) {
        self.data = data
        self.position = 0
    }
}

func asTSInput(payload: UnsafeMutablePointer<Void>) -> TSInput {
    return TSInput(payload: payload, read_fn: { payload, read in
        let pointer = UnsafeMutablePointer<Input>(payload)
        //print(pointer)
        var input = pointer.memory
        if (input.position >= input.length) {
            read.memory = 0;
            return UnsafePointer(strdup(""))
        }
        let previousPosition = input.position;
        input.position = input.length;
        read.memory = input.position - previousPosition
        pointer.memory = input
        //print(input.position, input.length)
        return UnsafePointer(input.data.bytes + 2) + previousPosition;
        
        }, seek_fn: { payload, character, byte in
            
            let pointer = UnsafeMutablePointer<Input>(payload)
            var input = pointer.memory
            input.position = byte;
            pointer.memory = input
            return byte < input.length ? 1 : 0
        }, encoding: TSInputEncodingUTF16)
}
