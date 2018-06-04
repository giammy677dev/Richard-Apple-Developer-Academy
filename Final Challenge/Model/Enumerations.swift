//
//  Enumerations.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 21/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation

// MARK: - RoadmapVisibility
enum RoadmapVisibility: Int16 {
    case isPublic = 0
    case isShared = 1
    case isPrivate = 2
}

// MARK: - UserPrivilege
enum UserPrivilege: Int16 {
    case isOwner = 0
    case isEditor = 1
    case isSubscribed = 2
}

// MARK: - Category
enum Category: Int16 {
    case Business = 0
    case Education = 1
    case Entertainment = 2
    case Food = 3
    case Travel = 4
    case Lifestyle = 5
    case Hobby = 6
    case Sport = 7
    case News = 8
    case Health = 9
    case Other = 10
    case Technology = 11
}
