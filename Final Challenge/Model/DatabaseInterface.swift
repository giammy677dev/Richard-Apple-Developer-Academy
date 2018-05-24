//
//  DatabaseInterface.swift
//  Final Challenge
//
//  Created by Stefano Formicola on 24/05/2018.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation
import CloudKit

class DatabaseInterface {
    
    static let shared = DatabaseInterface()
    static let ckManager = CloudKitManager.shared
    
    private init() {}
    
    public func save(_ node: Node) {
        
    }
    
    public func save(_ roadmap: Roadmap) {
        
    }
    
    public func save(_ step: Step) {
        
    }
    
    private func saveToCloud(record: CKRecord) {
        
    }
    
    private func saveToCoreData(){}
    
    private enum CKRecordTypes: String {
        case node = "Node"
        case step = "Step"
        case roadmap = "Roadmap"
    }
    private enum CKRecordFields: String {
        case title = "title"
        
    }
    
}
