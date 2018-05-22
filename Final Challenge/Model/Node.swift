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
    private var readingTimeInMinutes: Double?
    private var parent: Step
    
    //Methods:
    init(url: URL, title: String, parent: Step, tags: String?) {
        self.url = url
        self.title = title
        self.parent = parent
        
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
    
    func addTag(_ tag: [String]) {
        //
    }
    
    func removeTag(_ tag: [String]) {
        //
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.url == rhs.url
    }
    
}
