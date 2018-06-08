//
//  CurrentDataSingleton.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 29/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation

class CurrentData {

    static let shared = CurrentData()

    var roadmaps: [Roadmap]?
    var readingListByTags: [(tag: String, nodes: [Node])] = [(String, [Node])]()

    func load() { //Load roadmaps and nodes into the arrays
        //DatabaseInterface.shared.
    }
}
