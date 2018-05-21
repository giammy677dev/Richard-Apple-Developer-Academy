//
//  Node.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 21/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation

//MARK: - Node
class Node {
    //Parameters:
    var url: URL
    var title: String
    var tags: Set<String>?
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
    
    private func setTags(from string: String?) {
        
    }
    
    private func parseTags(from string: String) {
        
    }
    
    private func setReadingTime(url: URL) {
        
    }
    
    func edit(title: String? = nil) {
        
    }
    
    func addTag(_ tag: Array<String>) {
        
    }
    
    func removeTag(_ tag: Array<String>) {
        
    }
}
