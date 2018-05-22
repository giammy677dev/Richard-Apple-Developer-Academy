//
//  Step.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 21/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation

//MARK: - Step

class Step: NodeManager {
    //Parameters:
    var title: String
    var nodes: [Node]?
    var parent: Roadmap
    
    //Methods:
    init(title: String, parent: Roadmap) {
        self.title = title
        self.parent = parent
    }
    
    func addNode(node: Node) {
        if nodes == nil {
            nodes = [Node]()
        }
        nodes?.append(node)
    }
    
    func removeNode(node: Node) {
    }
}
