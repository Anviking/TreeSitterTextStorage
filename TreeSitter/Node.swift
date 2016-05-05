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
    case Proceed, IgnoreSiblings, IgnoreChildren, IgnoreChild(Int)
}

extension Node {
    
    public func forEach(block: Node -> Void) {
        let count = ts_node_child_count(self)
        guard count > 0 else { return }
        var child = ts_node_child(self, 0)
        for _ in 0 ..< count {
            block(child)
            child.forEach(block)
            child = ts_node_next_sibling(child)
        }
    }

    
    public func forEach(inRange range: NSRange, block: Node -> Void) {
        let count = ts_node_child_count(self)
        guard count > 0 else { return }
        var child = ts_node_child(self, 0)
        for _ in 0 ..< count {
            if child.range.intersectsRange(range) {
                block(child)
                child.forEach(block)
                child = ts_node_next_sibling(child)
            }
        }
    }
    
    /*
     func forEachWithOtherNode(other: Node, block: Node -> Void) {
     let countA = ts_node_child_count(self)
     let countB = ts_node_child_count(other)
     guard countA > 0 else { return }
     guard countB > 0 else { forEach(block); return }
     var childA = ts_node_child(self, 0)
     var childB = ts_node_child(self, 0)
     for i in 1 ..< max(countA, countB) {
     if ts_node_eq(childA, childB) {
     childA = ts_node_child(self, i)
     childB = ts_node_child(self, i)
     } else if childB.start > childA.start {
     // Left insert
     childA.
     }
     if child.range.intersectsRange(range) {
     block(child)
     child.forEach(block)
     child = ts_node_next_sibling(child)
     }
     }
     }
     */
    public func forEachUpwards(until: Node, block: Node -> Void) {
        guard !ts_node_eq(self, until) else { return }
        let parent = ts_node_parent(self)
        let count = ts_node_child_count(parent)
        guard !ts_node_eq(parent, until) else { return }
        guard count > 0 else { return }
        var child = self
        for _ in 0 ..< count {
            block(child)
            child = ts_node_next_sibling(child)
        }
        parent.forEachUpwards(until, block: block)
    }
    
    func _unchangedIndexes(set: NSMutableIndexSet) {
        let count = ts_node_child_count(self)
        if !hasChanges {
            set.addIndexesInRange(self.range)
            return
        }
        guard count > 0 else { return }
        var child = ts_node_child(self, 0)
        for _ in 0 ..< count {
            child._unchangedIndexes(set)
            child = ts_node_next_sibling(child)
        }
    }
    
    public var unchangedIndexes: NSMutableIndexSet {
        let set = NSMutableIndexSet()
        _unchangedIndexes(set)
        return set
    }
    
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
    
    public func stringInDocument(document: COpaquePointer) -> String {
        return String.fromCString(ts_node_string(self, document))!
    }
    
    public var children: NodeChildrenCollection {
        return NodeChildrenCollection(node: self)
    }
    
    public var symbol: UInt16 {
        return ts_node_symbol(self)
    }
}

public struct NodeChildrenCollection: CollectionType {
    
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
    public var endIndex: Int { return count - 1 }
    public subscript (index: Int) -> Node {
        return ts_node_child(node, index)
    }
    
    /// Return a *generator* over the elements.
    ///
    /// - Complexity: O(1).
    public func generate() -> IndexingGenerator<NodeChildrenCollection> {
        return IndexingGenerator(self)
    }
    
    /// A type that can represent a sub-range of an `Array`.
    //typealias SubSlice = ArraySlice<T>
    //subscript (subRange: Range<Int>) -> ArraySlice<T>
}

public struct NodeChildrenGenerator: GeneratorType, SequenceType {
    private var index = 0
    let node: Node
    public let count: Int
    init(node: Node) {
        self.count = ts_node_child_count(node)
        self.node = node
    }
    
    public mutating func next() -> Node? {
        defer { index += 1 }
        return ts_node_child(node, index)
    }
}
