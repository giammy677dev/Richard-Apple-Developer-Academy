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
    var isShared: Bool
    var isPublic: Bool
    var privilages: UserPrivilege
    var title: String
    var category: Category
    var steps: [Any]?
    
    //Methods:
    init(title: String, category: Category, visibility: RoadmapVisibility = RoadmapVisibility.isPrivate, privilages: UserPrivilege = UserPrivilege.isOwner) {
        self.visibility = visibility
        self.isShared = false
        self.isPublic = false
        self.title = title
        self.category = category
        self.privilages = privilages
    }
    
    
    func setShared() {
    }
    
    func setPublic() {
    }
    
    func setPrivate() {
    }
    
    func stopSharing() {
    }
    
    func share() {
    }
    
    func publish() {
    }
    
}
