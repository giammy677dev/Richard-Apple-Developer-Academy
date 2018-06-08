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
    private let uuid: UUID

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
    
    //Initialize new object from one other:
    init(roadmap: Roadmap) {
        self.title = roadmap.title
        self.category = roadmap.category
        self.privileges = roadmap.privileges
        self.visibility = roadmap.visibility
        self.lastReadTimestamp = roadmap.lastReadTimestamp
        self.uuid = roadmap.getRoadmapUUID()
        for step in roadmap.steps {
            self.steps.append(Step(step))
        }
    }
    
    func setLastRead(_ date: Date = Date()) {
        self.lastReadTimestamp = date
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
    
    func getRoadmapUUID() -> UUID {
        return self.uuid
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
