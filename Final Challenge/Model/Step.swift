//
//  Step.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 21/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation

// MARK: - Step

class Step: NodeManager, Equatable {

    //Parameters:
    var title: String
    var nodes: [Node]!
    var parent: UUID
    private let uuid: UUID
    var indexInParent: Int!

    //Methods:
    init(title: String, parent: UUID, id: UUID, index: Int? = nil) {
        self.title = title
        self.parent = parent
        self.uuid = id
        self.nodes = [Node]()
        if let _ = index {
            self.indexInParent = index
        }
    }

    //Initialize new object from one other:
    init(_ step: Step) {
        self.title = step.title
        self.parent = step.parent
        self.uuid = step.getStepUUID()
        self.indexInParent = step.indexInParent
        for elem in step.nodes {
            self.nodes.append(Node(elem))
        }
    }

    func addNode(_ node: Node) {
        node.parent = self.uuid
        node.indexInParent = self.nodes.count
        self.nodes.append(node)
    }

    func removeNode(_ node: Node) {
        if let index = self.nodes.index(of: node) {
            self.nodes.remove(at: index)
            self.nodes.forEach { (node) in
                node.indexInParent = self.nodes.index(of: node)
            }
            Tag.shared.rRemove(node)
        }
    }

    func getStepUUID() -> UUID {
        return self.uuid
    }

    static func == (lhs: Step, rhs: Step) -> Bool {
        return lhs.parent == rhs.parent && lhs.title == rhs.title
    }
}
