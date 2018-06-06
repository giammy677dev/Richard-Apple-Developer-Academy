//
//  DataSupportRoadmap.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 06/06/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation

class DataSupportRoadmap {
    // Properties:
    static let shared: DataSupportRoadmap = DataSupportRoadmap.init()
    
    private var title: String
    private var notivicationOn: Bool
    private var category: Category
    
    private init() {
        self.title = ""
        self.notivicationOn = true
        self.category = Category.other
    }
    
    // Methods:
    public func getTitle() -> String {
        return self.title
    }
    
    public func setTitle(_ title: String) {
        self.title = title
    }
    
    public func getNotification() -> Bool {
        return self.notivicationOn
    }
    
    public func setNotification(_ isOn: Bool) {
        self.notivicationOn = isOn
    }
    
    public func getCategory() -> Category {
        return self.category
    }
    
    public func setCategory(_ category: Category) {
        self.category = category
    }
    
    public func setCategory() {
        self.category = Category.other
    }
}
