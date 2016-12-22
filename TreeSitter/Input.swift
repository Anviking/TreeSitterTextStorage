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
    var data: Data
    var position: UInt32
    var length: UInt32 {
        return UInt32(data.count - 2)
    }
    
    public init(data: Data) {
        self.data = data
        self.position = 0
    }
}

func asTSInput(_ payload: UnsafeMutableRawPointer) -> TSInput {
    return TSInput(payload: payload, read: { payload, read in
        //let pointer = UnsafeMutablePointer<Input>(payload)
        
        //print(pointer)
        let input = payload!.load(as: Input.self)
        if (input.position >= input.length) {
            read?.pointee = 0;
            return UnsafePointer(strdup(""))
        }
        let previousPosition = input.position
        input.position = (input.length)
        read?.pointee = UInt32(input.position - previousPosition)
        payload?.storeBytes(of: input, as: Input.self)
        //print(input.position, input.length)
        
        return input.data.withUnsafeBytes { $0 } + 2 + Int(previousPosition);
        
    }, seek: { payload, character, byte in
            
            let input = payload!.load(as: Input.self)
            input.position = byte
            //pointer?.pointee = input
            return byte < input.length ? 1 : 0
        }, encoding: TSInputEncodingUTF16)
}
