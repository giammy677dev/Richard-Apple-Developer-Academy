//
//  Taggable.swift
//  Final Challenge
//
//  Created by Stefano Formicola on 21/05/2018.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation

protocol Taggable: Equatable {
    var tags: Set<String> { get set }

    func addTags(_ tagArray: [String])
    func removeTag(_ tag: String)

    static func == (lhs: Self, rhs: Self) -> Bool
}
