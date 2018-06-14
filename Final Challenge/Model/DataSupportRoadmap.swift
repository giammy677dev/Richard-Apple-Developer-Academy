//
//  DataSupportRoadmap.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 06/06/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation

class DataSupportRoadmap {
    // Properties:
    static let shared: DataSupportRoadmap = DataSupportRoadmap.init()

    private var notivicationOn: Bool
    //For Roadmap:
    private var roadmapTitle: String
    private var roadmapCategory: Category
    //For Step:
    private var stepTitle: String
    //For Node:
    private var nodeUrl: URL?
    private var nodeTitle: String
    private var nodeText: String
    //Objects:
    var roadmap: WritableRoadmap?

    private init() {
        self.notivicationOn = true
        self.roadmapTitle = ""
        self.roadmapCategory = Category.other
        self.stepTitle = ""
        self.nodeUrl = URL(string: "www.apple.com")
        self.nodeTitle = ""
        self.nodeText = ""
    }

    // Methods:
    public func getTitleRoadmap() -> String {
        return self.roadmapTitle
    }

    public func setTitleRoadmap(_ title: String) {
        self.roadmapTitle = title
    }

    public func getTitleStep() -> String {
        return self.stepTitle
    }

    public func setTitleStep(_ title: String) {
        self.stepTitle = title
        print(self.getTitleStep())
    }

    public func getNotification() -> Bool {
        return self.notivicationOn
    }

    public func setNotification(_ isOn: Bool) {
        self.notivicationOn = isOn
    }

    public func getRoadmapCategory() -> Category {
        return self.roadmapCategory
    }

    public func setRoadmapCategory(_ category: Category = Category.other) {
        self.roadmapCategory = category
    }

    public func createRoadmap() {
        self.roadmap = WritableRoadmap(title: roadmapTitle, category: roadmapCategory, lastRead: Date(), id: UUID())
    }

    public func createStep(_ indexInParent: Int) {
        if self.roadmap != nil {
            let step: Step = Step(title: self.stepTitle, parent: self.roadmap!.getRoadmapUUID(), id: UUID(), index: indexInParent)
            self.roadmap?.addStep(step)
        }
    }
    
    public func saveRoadmap() {
        if let roadMap = self.roadmap {
            DatabaseInterface.shared.save(roadMap)
            if let steps = roadMap.steps {
                self.saveSteps(steps: steps)
            }
        } else {
            debugPrint("Error on save roadmap!")
        }
    }
    
    public func saveSteps(steps: [Step]) {
        for step in steps {
            DatabaseInterface.shared.save(step)
            if let nodes = step.nodes {
                self.saveNodes(nodes: nodes)
            }
        }
    }
    
    public func saveNodes(nodes: [Node]) {
        for node in nodes {
            DatabaseInterface.shared.save(node)
        }
    }
}
