//
//  Tag.swift
//  Final Challenge
//
//  Created by Stefano Formicola on 21/05/2018.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation

class Tag {
    // Singleton instance
    static let shared: Tag = Tag()
    var items: [String : [Any]] = [:]
    
    private init() {}
    
    func add<T: Taggable>(_ obj: T, forTag tag: String) {
        
    }
    
    func remove<T: Taggable>(_ obj: T, forTag tag: String) {
        guard var itemArray = Tag.shared.items[tag] as? [T] else { return }
        if let index = itemArray.index(where: { $0 == obj }) {
            itemArray.remove(at: index)
        }
    }
    
    func rRemove<T: Taggable>(_ obj: T) {
        /// Removes recursively every reference of the object
        for tag in obj.tags {
            remove(obj, forTag: tag)
        }
    }
    
    class func parseTags(from str: String?) -> [String] {
        guard let string = str else { return [] }
        return []
    }
    
}
