//
//  SubscribedRoadmap.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 21/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation
import CloudKit

class SubscribedRoadmap: Roadmap, Updatable {
    //Parameters:
    private var ckToken: CKServerChangeToken?
    
    //Methods:
    convenience init(title: String, category: Category, ckToken: CKServerChangeToken, lastRead: Date, id: UUID) {
        self.init(title: title, category: category,lastRead: lastRead, id: id)
        self.ckToken = ckToken
    }
    
    func fetch() {
    }
    
    func setNotifications() {
    }
    
    func stopNotifications() {
    }
    
    func stopSubscription() {
    }
    
    
}
