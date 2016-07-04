//
//  Node.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-05-05.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation
import TreeSitterRuntime

public typealias Node = TSNode

public enum TraverseAction {
    case proceed, ignoreSiblings, ignoreChildren, ignoreChild(Int)
}

extension Node {
    
    public var hasChanges: Bool {
        return ts_node_has_changes(self)
    }
    
    public var start: Int {
        return ts_node_start_char(self)
    }
    
    public var end: Int {
        return ts_node_end_char(self)
    }
    
    public var range: NSRange {
        return NSMakeRange(start, end - start)
    }
    
    public func stringInDocument(_ document: OpaquePointer) -> String {
        return String(cString: ts_node_string(self, document))
    }
    
    public var children: NodeChildrenCollection {
        return NodeChildrenCollection(node: self)
    }
    
    public var symbol: UInt16 {
        return ts_node_symbol(self)
    }
}

public struct NodeChildrenCollection: Collection {
    
    private var index = 0
    let node: Node
    public let count: Int
    init(node: Node) {
        self.count = ts_node_child_count(node)
        self.node = node
    }
    
    public var startIndex: Int { return 0 }
    
    /// A "past-the-end" element index; the successor of the last valid
    /// subscript argument.
    public var endIndex: Int { return count }
    public subscript (index: Int) -> Node {
        return ts_node_child(node, index)
    }
    
    public func index(after i: Int) -> Int {
        return i + 1
    }
    
    /// A type that can represent a sub-range of an `Array`.
    //typealias SubSlice = ArraySlice<T>
    //subscript (subRange: Range<Int>) -> ArraySlice<T>
}


public struct TraverseInRangeGenerator: IteratorProtocol, Sequence {
    let index: Int
    let document: Document
    var children: IndexingIterator<NodeChildrenCollection>
    init(node: Node, index: Int, document: Document) {
        self.index = index
        self.document = document
        
        children = node.children.makeIterator()
    }
    
    public mutating func next() -> Node? {
        for child in children where child.range.containsIndex(index) {
            children = child.children.makeIterator()
            return child
        }
        return nil
    }
}
