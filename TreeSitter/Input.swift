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
    var position: Int
    var length: Int {
        return data.count - 2
    }
    
    public init(data: Data) {
        self.data = data
        self.position = 0
    }
}

func asTSInput(_ payload: UnsafeMutablePointer<Void>) -> TSInput {
    return TSInput(payload: payload, read_fn: { payload, read in
        let pointer = UnsafeMutablePointer<Input>(payload)
        //print(pointer)
        let input = pointer?.pointee
        if (input?.position >= input?.length) {
            read?.pointee = 0;
            return UnsafePointer(strdup(""))
        }
        let previousPosition = input?.position;
        input?.position = (input?.length)!;
        read?.pointee = (input?.position)! - previousPosition!
        pointer?.pointee = input!
        //print(input.position, input.length)
        
        let bytes: UnsafePointer<Void> = input!.data.withUnsafeBytes({ $0 })


        return UnsafePointer(bytes) + 2 + previousPosition!;
        
        }, seek_fn: { payload, character, byte in
            
            let pointer = UnsafeMutablePointer<Input>(payload)
            let input = pointer?.pointee
            input?.position = byte;
            pointer?.pointee = input!
            return byte < input!.length ? 1 : 0
        }, encoding: TSInputEncodingUTF16)
}
