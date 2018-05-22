//
//  PersistenceManager.swift
//  Final Challenge
//
//  Created by Stefano Formicola on 22/05/2018.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation

class PersistenceManager {
    /// This singleton instance is responsible for the offline
    /// data persistence on the device and will take care of
    /// the data fetched from the remote database and all the
    /// saved roadmaps.
    
    // Singleton
    static let sharedInstance: PersistenceManager = {
        return PersistenceManager()
    }()
    
    private init() { }
    
    //MARK: - Instance properties
    var userRoadmaps: [Roadmap] = []
    var userDefaults: UserDefaults = {
        return UserDefaults.standard
    }()
    
    //MARK: - Instance methods
    func save() {
        
    }
}
