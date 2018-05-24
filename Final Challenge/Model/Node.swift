//
//  Node.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 21/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation

//MARK: - Node
class Node: Taggable {    
    
    //Parameters:
    var url: URL
    var title: String
    var extractedText: String
    var isTextProperlyExtracted: Bool
    var creationTimestamp: Date
    private var readingTimeInMinutes: Double?
    private var parent: Step
    
    //Methods:
    init(url: URL, title: String, parent: Step, tags: String?, text: String, propExtracted: Bool, creationTime: Date = Date()) {
        self.url = url
        self.title = title
        self.parent = parent
        self.extractedText = text
        self.isTextProperlyExtracted = propExtracted
        self.creationTimestamp = creationTime
        
        if let _ = tags {
            let tagArray = Tag.parseTags(from: tags)
            self.addTags(tagArray)
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
    
    //MARK: - Taggable protocol conformance
    var tags: Set<String> = Set<String>()
    
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
        return lhs.url == rhs.url
    }
    
}
