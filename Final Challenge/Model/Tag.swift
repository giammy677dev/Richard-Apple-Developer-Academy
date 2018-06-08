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
    var items: [String: [Any]] = [:]

    private init() {}

    func add<T: Taggable>(_ obj: T, forTag tag: String) {
        /// Adds a reference of a taggable element for a tag
        guard var arrayTag = items[tag] as? [T] else { items[tag] = [obj]; return }
        if (arrayTag.contains(obj)) {
            arrayTag.append(obj)
        }
    }

    func remove<T: Taggable>(_ obj: T, forTag tag: String) {
        /// Removes a reference of a taggable element for a tag
        guard var itemArray = Tag.shared.items[tag] as? [T] else { return }
        if let index = itemArray.index(of: obj) {
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
        /// This function is used to parse tags for a new node from a string.
        /// Every tag is marked with a '#' symbol followed with the tag.
        /// Return value is an array of strings.
        guard let string = str, str?.count != 0 else { return [] }
        let hashtagRegex = try! NSRegularExpression(pattern: "#(\\w++)", options: .caseInsensitive)

        let regexResults = hashtagRegex.matches(in: string, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: string.count))

        let tagsArray = regexResults.map {
            (string as NSString).substring(with: $0.range(at: 1))
        }

        return tagsArray
    }

}
