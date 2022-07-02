//
//  ParameterController.swift
//  AUFramework
//
//  Created by Amelia Murphy on 6/21/22.
//

import Foundation
import AVFoundation
import CoreAudio

public class Node {
    var value: AUParameter
    var next: Node?
    weak var prev: Node?
    
    init(val: AUParameter) {
        self.value = val
    }
}

public class LinkedList {
    fileprivate var head: Node?
    private var tail: Node?
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    public var first: Node? {
        return head
    }
    
    public var last: Node? {
        return tail
    }
    
    public func append(val: AUParameter) {
        let newNode = Node(val: val)
        
        if let tailNode = tail {
            newNode.prev = tailNode
            tailNode.next = newNode
        }
        
        else {
            head = newNode
        }
        
        tail = newNode
    }
}

public class ParameterController {
    private let parameterList: LinkedList?
    private let parameterTree: AUParameterTree?

    init(pList: LinkedList, pTree: AUParameterTree) {
        self.parameterList = pList
        self.parameterTree = pTree
    }
    
    public func getTree() -> AUParameterTree {
        return self.parameterTree!
    }
    
    private func addParameterToTree()
    
}

