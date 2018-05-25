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
    
    static let shared: DatabaseInterface = DatabaseInterface()
    private let ckManager: CloudKitManager
    
    private init() {
        self.ckManager = CloudKitManager.shared
    }
    
    public func save(_ node: Node) {
        /// Saves a node in local and cloud DB. If the node doesn't exist it creates a new one and saves it.
        //MARK: - Save to CloudKit
        let recordID = CKRecordID(recordName: node.uuid.uuidString)
        self.ckManager.privateDB.fetch(withRecordID: recordID) { (record, error) in
            if error != nil {
                //TODO: - Error handling here
                debugPrint(error!.localizedDescription)
            }
            
            let savedRecord = self.nodeToRecord(record: record, node: node)
            self.ckManager.saveRecord(savedRecord)
        }
        
        //MARK: - Save to CoreData
        saveToCoreData()
    }
    
    public func save(_ roadmap: Roadmap) {
        
    }
    
    public func save(_ step: Step) {
        
    }
    
    //MARK: - Interface to deleting operations
    public func deleteRoadmap(_ roadmap: Roadmap) {
        CoreDataController.shared.deleteRoadmap(roadmap) //Delete roadmap from CoreData DB
        CloudKitManager.shared.deleteRoadmap(CKRecordID(recordName: roadmap.uuid.uuidString)) //Delete roadmap from CloudKit DB
    }
    
    public func deleteStep(_ step: Step) {
        CoreDataController.shared.deleteStep(step) //Delete step from CoreData DB
        CloudKitManager.shared.deleteStep(CKRecordID(recordName: step.uuid.uuidString)) //Delete step from CloudKit DB
    }
    
    public func deleteNode(_ node: Node) {
        CoreDataController.shared.deleteNode(node) //Delete node from CoreData DB
        CloudKitManager.shared.deleteNode(CKRecordID(recordName: node.uuid.uuidString)) //Delete roadmap from CloudKit DB
    }
    
    private func saveToCloud(record: CKRecord) {
        
    }
    
    private func saveToCoreData(){}
    
    private func nodeToRecord(record: CKRecord?, node: Node) -> CKRecord {
        /// When a new record has to be saved it creates a new one otherwise it re-saves all the key-values
        if let _ = record {
            record!.setValue(node.creationTimestamp, forKey: "creationTimestamp")
            record!.setValue(node.extractedText, forKey: "extractedText")
            record!.setValue(node.isFlagged, forKey: "isFlagged")
            record!.setValue(node.isRead, forKey: "isRead")
            record!.setValue(node.isTextProperlyExtracted, forKey: "isTextProperlyExtracted")
            record!.setValue(node.tags, forKey: "tags")
            record!.setValue(node.title, forKey: "title")
            record!.setValue(node.url, forKey: "url")
            record!.setValue(node.uuid, forKey: "uuid")
            
            return record!
        }
        
        let recordID = CKRecordID(recordName: node.uuid.uuidString)
        let newRecord = CKRecord(recordType: CKRecordTypes.node.rawValue, recordID: recordID)
        
        newRecord.setValue(node.creationTimestamp, forKey: "creationTimestamp")
        newRecord.setValue(node.extractedText, forKey: "extractedText")
        newRecord.setValue(node.isFlagged, forKey: "isFlagged")
        newRecord.setValue(node.isRead, forKey: "isRead")
        newRecord.setValue(node.isTextProperlyExtracted, forKey: "isTextProperlyExtracted")
        newRecord.setValue(node.tags, forKey: "tags")
        newRecord.setValue(node.title, forKey: "title")
        newRecord.setValue(node.url, forKey: "url")
        newRecord.setValue(node.uuid, forKey: "uuid")
        
        return newRecord
    }
    
    private enum CKRecordTypes: String {
        case node = "Node"
        case step = "Step"
        case roadmap = "Roadmap"
    }
    private enum CKRecordFields: String {
        case title = "title"
        
    }
    
}
