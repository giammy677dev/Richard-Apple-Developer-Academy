//
//  Step.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 21/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation

//MARK: - Step

class Step: NodeManager, Equatable {

    //Parameters:
    var title: String
    var nodes: [Node]?
    var parent: Roadmap
    
    //Methods:
    init(title: String, parent: Roadmap) {
        self.title = title
        self.parent = parent
    }
    
    func addNode(_ node: Node) {
        if nodes == nil {
            nodes = [Node]()
        }
        nodes?.append(node)
    }
    
    func removeNode(_ node: Node) {
        guard var container = nodes
            else { return }
        let index: Int? = container.index(of: node)
        guard let target = index
            else { return }
        container.remove(at: target)
        Tag.shared.rRemove(node)
    }

    static func == (lhs: Step, rhs: Step) -> Bool {
        return lhs.parent == rhs.parent && lhs.title == rhs.title
    }
}
