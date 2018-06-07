//
//  Roadmap.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 21/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation
// MARK: - Class Roadmap
class Roadmap: Sharable, Equatable {

    //Parameters:
    var visibility: RoadmapVisibility
    var isShared: Bool {return RoadmapVisibility.isShared == self.visibility}
    var isPublic: Bool {return RoadmapVisibility.isPublic == self.visibility}
    var privileges: UserPrivilege
    var title: String
    var category: Category
    var steps: [Step]!
    var lastReadTimestamp: Date
    var uuid: UUID

    //Methods:
    init(title: String, category: Category, visibility: RoadmapVisibility = RoadmapVisibility.isPrivate, privileges: UserPrivilege = UserPrivilege.isOwner, lastRead: Date, id: UUID) {
        self.title = title
        self.category = category
        self.privileges = privileges
        self.visibility = visibility
        self.lastReadTimestamp = lastRead
        self.uuid = id
        self.steps = [Step]()
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

    func addStep(_ step: Step) {
        step.parent = self.uuid
        step.indexInParent = self.steps.count
        self.steps.append(step)
    }

    func removeStep(_ step: Step) {
        if let index = self.steps.index(of: step) {
            self.steps.remove(at: index)
            self.steps.forEach { (step) in
                step.indexInParent = self.steps.index(of: step)
            }
        }
    }

    static func == (lhs: Roadmap, rhs: Roadmap) -> Bool {
        return lhs.title == rhs.title
    }

    //TO-DO: - Complete the following functions when we will have the DB
    func share() {
    }

    func publish() {
    }

}
