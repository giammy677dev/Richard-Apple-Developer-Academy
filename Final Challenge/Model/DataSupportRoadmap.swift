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

    private var roadmap: WritableRoadmap
    private var step: Step
    private var notivicationOn: Bool

    private init() {
        self.roadmap = WritableRoadmap(title: "", category: Category.other, lastRead: Date(), id: UUID())
        self.step = Step(title: "", parent: self.roadmap.uuid, id: UUID())
        self.notivicationOn = true
    }

    // Methods:
    public func getTitleRoadmap() -> String {
        return self.roadmap.title
    }

    public func setTitleRoadmap(_ title: String) {
        self.roadmap.title = title
    }
    
    public func getTitleStep() -> String {
        return self.step.title
    }
    
    public func setTitleStep(_ title: String) {
        self.step.title = title
    }

    public func getNotification() -> Bool {
        return self.notivicationOn
    }

    public func setNotification(_ isOn: Bool) {
        self.notivicationOn = isOn
    }

    public func getRoadmapCategory() -> Category {
        return self.roadmap.category
    }

    public func setRoadmapCategory(_ category: Category = Category.other) {
        self.roadmap.category = category
    }
    
    //Call this function after roadmap creation and saving it on DB
    public func resetObjectRoadmap() {
        //New UUID
        self.roadmap.uuid = UUID()
        self.step.parent = self.roadmap.uuid
        //Reset roadmap's title, category and lastRead
        self.roadmap.edit()
        self.roadmap.setLastRead()
    }
    
    public func resetObjectStep() {
        self.setTitleStep("")
        self.step.uuid = UUID()
        
    }
    
    public func resetObjectNode() {
        
    }
    
    private func addStepToRoadmap(_ step: Step) {
        self.roadmap.addStep(step)
    }
}
