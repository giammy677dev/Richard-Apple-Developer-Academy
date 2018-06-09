//
//  Node.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 21/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation

// MARK: - Node
class Node: Taggable {

    //Parameters:
    var url: URL
    var title: String
    private let uuid: UUID
    var extractedText: String
    var isTextProperlyExtracted: Bool
    var creationTimestamp: Date
    var isRead: Bool
    var isFlagged: Bool
    private var readingTimeInMinutes: Double?
    var parent: UUID
    var indexInParent: Int!

    //Methods:
    init(url: URL, title: String, id: UUID, parent: UUID, tags: String?, text: String, propExtracted: Bool, creationTime: Date = Date(), propRead: Bool = false, propFlagged: Bool = false) {
        self.url = url
        self.title = title
        self.parent = parent
        self.extractedText = text
        self.isTextProperlyExtracted = propExtracted
        self.creationTimestamp = creationTime
        self.uuid = id
        self.isRead = propRead
        self.isFlagged = propFlagged

        if let _ = tags {
            let tagArray = Tag.parseTags(from: tags)
            self.addTags(tagArray)
        }
    }

    init(url: URL, title: String, id: UUID, parent: UUID, tags: Set<String>?, text: String, propExtracted: Bool, creationTime: Date = Date(), propRead: Bool = false, propFlagged: Bool = false, index: Int?) {
        self.url = url
        self.title = title
        self.parent = parent
        self.extractedText = text
        self.isTextProperlyExtracted = propExtracted
        self.creationTimestamp = creationTime
        self.uuid = id
        self.isRead = propRead
        self.isFlagged = propFlagged

        if let _ = tags {
            self.tags = tags!
        }
        if let _ = index {
            self.indexInParent = index
        }
    }

    //Initialize new object from one other:
    init(_ node: Node) {
        self.url = node.url
        self.title = node.title
        self.parent = node.parent
        self.extractedText = node.extractedText
        self.isTextProperlyExtracted = node.isTextProperlyExtracted
        self.creationTimestamp = node.creationTimestamp
        self.uuid = node.getNodeUUID()
        self.isRead = node.isRead
        self.isFlagged = node.isFlagged

        for elem in node.tags {
            self.tags.insert(elem)
        }
    }

    private func analyze(url: URL) {

    }

    private func getTitle(url: URL) {

    }

    private func setReadingTime(url: URL) {

    }

    func edit(title: String? = nil) {

    }

    func getNodeUUID() -> UUID {
        return uuid
    }

    // MARK: - Taggable protocol conformance
    var tags: Set<String> = Set<String>()

    func addTag(_ tag: String) {
        // This method receive a string and sets a node's tags
        tags.insert(tag)
        Tag.shared.add(self, forTag: tag)
    }

    func addTags(_ tagArray: [String]) {
        // This method receive an array of string and sets a node's tags
        for tag in tagArray {
            tags.insert(tag)
            Tag.shared.add(self, forTag: tag)
        }
    }

    func removeTag(_ tag: String) {
        // This method receive a string and removes it as node tag
        tags.remove(tag)
        Tag.shared.remove(self, forTag: tag)
    }

    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.uuid == rhs.uuid
    }

}
