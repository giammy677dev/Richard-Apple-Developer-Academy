//
//  Enumerations.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 21/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation

//MARK: - RoadmapVisibility
enum RoadmapVisibility: Int16 {
    case isPublic = 0
    case isShared = 1
    case isPrivate = 2
}

//MARK: - UserPrivilege
enum UserPrivilege: Int16 {
    case isOwner = 0
    case isEditor = 1
    case isSubscribed = 2
}

//MARK: - Category
enum Category: Int16 {
    case travel = 0
}
