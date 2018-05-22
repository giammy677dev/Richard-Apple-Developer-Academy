//
//  Roadmap.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 21/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation
//MARK: - Class Roadmap
class Roadmap: Sharable {
    //Parameters:
    var visibility: RoadmapVisibility
    var isShared: Bool {return RoadmapVisibility.isShared == self.visibility}
    var isPublic: Bool {return RoadmapVisibility.isPublic == self.visibility}
    var privilages: UserPrivilege
    var title: String
    var category: Category
    var steps: [Step]?
    
    //Methods:
    init(title: String, category: Category, visibility: RoadmapVisibility = RoadmapVisibility.isPrivate, privilages: UserPrivilege = UserPrivilege.isOwner) {
        self.title = title
        self.category = category
        self.privilages = privilages
        self.visibility = visibility
    }

    func addStepInQueue(step: Step) {
        if steps == nil {
            steps = [Step]()
        }
        steps?.append(step)
    }

    func removeStep(step: Step) {
        guard var container = steps
            else { return }
        var index: Int? = container.index(of: step)
        guard let target = index
            else { return }
        container.remove(at: target)
    }
    
    func setShared() {
        self.visibility = RoadmapVisibility.isShared
    }
    
    func setPublic() {
        self.visibility = RoadmapVisibility.isPublic
    }
    
    func setPrivate() {
        self.visibility = RoadmapVisibility.isPrivate
    }
    
    func stopSharing() {
        if visibility == RoadmapVisibility.isShared {
            visibility = RoadmapVisibility.isPrivate
        }
    }

    //TO-DO: - Complete the following functions when we will have the DB
    func share() {
    }
    
    func publish() {
    }
    
}
