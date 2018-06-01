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
    private let cdController: CoreDataController
    
    private init() {
        self.ckManager = CloudKitManager.shared
        self.cdController = CoreDataController.shared
    }
    
    //MARK: Interfaces to save elements simultaneously on CloudKit and on CoreData
    
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
        saveToCoreData(node: node)
    }
    
    public func save(_ roadmap: Roadmap) {
        /// Saves a roadmap in local and cloud DB. If the roadmap doesn't exist it creates a new one and saves it.
        let recordID = CKRecordID(recordName: roadmap.uuid.uuidString)
        self.ckManager.privateDB.fetch(withRecordID: recordID) { (record, error) in
            if error != nil {
                //TODO: - Error handling here
                debugPrint(error!.localizedDescription)
            }
            
            let savedRecord = self.roadmapToRecord(record: record, roadmap: roadmap)
            self.ckManager.saveRecord(savedRecord)
        }
        
        //MARK: - Save to CoreData
        saveToCoreData(roadmap: roadmap)
    }
    
    public func save(_ step: Step) {
        /// Saves a step in local and cloud DB. If the step doesn't exist it creates a new one and saves it.
        let recordID = CKRecordID(recordName: step.uuid.uuidString)
        self.ckManager.privateDB.fetch(withRecordID: recordID) { (record, error) in
            if error != nil {
                //TODO: - Error handling here
                debugPrint(error!.localizedDescription)
            }
            
            let savedRecord = self.stepToRecord(record: record, step: step)
            self.ckManager.saveRecord(savedRecord)
        }
        
        //MARK: - Save to CoreData
        interfaceCDSaveStep(step)
    }
    
    //MARK: - Save elements in Core Data
    
    //Save Roadmap on CoreData
    private func saveToCoreData(roadmap: Roadmap) { //Save single roadmap with steps and nodes
        cdController.saveRecursively(roadmap)
    }
    
    //Save an array of Roadmaps on CoreData
    private func saveToCoreData(roadmaps: [Roadmap]) { //Save an array of roadmaps with steps. Nodes must already exist in memory.
        cdController.saveRecursively(roadmaps)
    }
    
    //Function to prepare Step saving on CoreData DataBase:
    private func interfaceCDSaveStep(_ step: Step) {
        //Get elements nedded for saving Step
        guard let cdRoadmap = cdController.fetchCDRoadmap(uuid: step.parent) else {
            debugPrint("Error on Roadmap fetching from CoreData!")
            return
        }
        let roadmap = cdController.roadmapFromRecord(cdRoadmap)
        
        //Call the function to save Step on CoreData
        saveToCoreData(step: step, roadmap: roadmap)
    }
    
    //Save Step on CoreData, need an interface:
    private func saveToCoreData(step: Step, roadmap: Roadmap) { //Save a step in memory and link it to a roadmap
        guard let _ = cdController.updateStep(step, of: roadmap) else {
            debugPrint("Error on save step in local memory")
            return
        }
    }
    
    //Save Node on CoreData
    private func saveToCoreData(node: Node) { //Save a node in memory
        guard let _ = cdController.updateNode(node) else {
            debugPrint("Error on save node in local memory")
            return
        }
    }
    
    //MARK: - Interface to deleting operations
    public func deleteRoadmap(_ roadmap: Roadmap) {
        cdController.deleteRoadmap(roadmap) //Delete roadmap from CoreData DB
        ckManager.deleteRoadmap(CKRecordID(recordName: roadmap.uuid.uuidString)) //Delete roadmap from CloudKit DB
    }
    
    public func deleteStep(_ step: Step) {
        cdController.deleteStep(step) //Delete step from CoreData DB
        ckManager.deleteStep(CKRecordID(recordName: step.uuid.uuidString)) //Delete step from CloudKit DB
    }
    
    public func deleteNode(_ node: Node) {
        cdController.deleteNode(node) //Delete node from CoreData DB
        ckManager.deleteNode(CKRecordID(recordName: node.uuid.uuidString)) //Delete roadmap from CloudKit DB
    }
    
    //MAKE: - Load data from Database
    
    func loadRoadmaps() -> [Roadmap]? {
        return cdController.getFullRoadmapRecords()
    }
    
    func loadNodes() -> [Node]? {
        return cdController.getEveryNodeRecord()
    }
  
    
    private func roadmapToRecord(record: CKRecord?, roadmap: Roadmap) -> CKRecord {
        
        if let record = record {
            record.setValue(roadmap.category, forKey: "category")
            record.setValue(roadmap.isPublic, forKey: "isPublic")
            record.setValue(roadmap.isShared, forKey: "isShared")
            record.setValue(roadmap.lastReadTimestamp, forKey: "lastReadTimestamp")
            record.setValue(roadmap.privileges, forKey: "privileges")
            record.setValue(roadmap.steps, forKey: "steps")
            record.setValue(roadmap.title, forKey: "title")
            record.setValue(roadmap.uuid, forKey: "uuid")
            record.setValue(roadmap.visibility, forKey: "visibility")

        }
        
        let recordID = CKRecordID(recordName: roadmap.uuid.uuidString)
        let newRecord = CKRecord(recordType: K.CKRecordTypes.roadmap, recordID: recordID)
        
        newRecord.setValue(roadmap.category, forKey: "category")
        newRecord.setValue(roadmap.isPublic, forKey: "isPublic")
        newRecord.setValue(roadmap.isShared, forKey: "isShared")
        newRecord.setValue(roadmap.lastReadTimestamp, forKey: "lastReadTimestamp")
        newRecord.setValue(roadmap.privileges, forKey: "privileges")
        newRecord.setValue(roadmap.steps, forKey: "steps")
        newRecord.setValue(roadmap.title, forKey: "title")
        newRecord.setValue(roadmap.uuid, forKey: "uuid")
        newRecord.setValue(roadmap.visibility, forKey: "visibility")
        
        return newRecord
    }
    
    private func stepToRecord(record: CKRecord?, step: Step) -> CKRecord {
        /// When a new record has to be saved it creates a new one otherwise it re-saves all the key-values
        if let record = record {
            record.setValue(step.nodes, forKey: "nodes")
            record.setValue(step.title, forKey: "title")
            record.setValue(step.uuid, forKey: "uuid")
  
            // Set the reference to the parent and the delete cascade update policy
            let parentID = CKRecordID(recordName: step.parent.uuidString)
            let parentReference = CKReference(recordID: parentID, action: .deleteSelf)
            record.parent = parentReference

            return record
        }
        
        let recordID = CKRecordID(recordName: step.uuid.uuidString)
        let newRecord = CKRecord(recordType: K.CKRecordTypes.step, recordID: recordID)
        
        newRecord.setValue(step.nodes, forKey: "nodes")
        newRecord.setValue(step.title, forKey: "title")
        newRecord.setValue(step.uuid, forKey: "uuid")
        
        // Set the reference to the parent and the delete cascade update policy
        let parentID = CKRecordID(recordName: step.parent.uuidString)
        let parentReference = CKReference(recordID: parentID, action: CKReferenceAction.deleteSelf)
        newRecord.parent = parentReference
        
        return newRecord
    }
    
    private func nodeToRecord(record: CKRecord?, node: Node) -> CKRecord {
        /// When a new record has to be saved it creates a new one otherwise it re-saves all the key-values
        if let record = record {
            record.setValue(node.creationTimestamp, forKey: "creationTimestamp")
            record.setValue(node.extractedText, forKey: "extractedText")
            record.setValue(node.isFlagged, forKey: "isFlagged")
            record.setValue(node.isRead, forKey: "isRead")
            record.setValue(node.isTextProperlyExtracted, forKey: "isTextProperlyExtracted")
            record.setValue(node.tags, forKey: "tags")
            record.setValue(node.title, forKey: "title")
            record.setValue(node.url, forKey: "url")
            record.setValue(node.uuid, forKey: "uuid")
            
            // Set the reference to the parent and the delete cascade update policy
            let parentID = CKRecordID(recordName: node.parent.uuidString)
            let parentReference = CKReference(recordID: parentID, action: CKReferenceAction.deleteSelf)
            record.parent = parentReference
            
            return record
        }
        
        let recordID = CKRecordID(recordName: node.uuid.uuidString)
        let newRecord = CKRecord(recordType: K.CKRecordTypes.node, recordID: recordID)
        
        newRecord.setValue(node.creationTimestamp, forKey: "creationTimestamp")
        newRecord.setValue(node.extractedText, forKey: "extractedText")
        newRecord.setValue(node.isFlagged, forKey: "isFlagged")
        newRecord.setValue(node.isRead, forKey: "isRead")
        newRecord.setValue(node.isTextProperlyExtracted, forKey: "isTextProperlyExtracted")
        newRecord.setValue(node.tags, forKey: "tags")
        newRecord.setValue(node.title, forKey: "title")
        newRecord.setValue(node.url, forKey: "url")
        newRecord.setValue(node.uuid, forKey: "uuid")
        
        // Set the reference to the parent and the delete cascade update policy
        let parentID = CKRecordID(recordName: node.parent.uuidString)
        let parentReference = CKReference(recordID: parentID, action: CKReferenceAction.deleteSelf)
        newRecord.parent = parentReference
        
        return newRecord
    }

    func createUniqueUUID() -> UUID {
        var id: UUID

        repeat {
            id = UUID()
        } while (cdController.isUUIDInUse(id))

        return id
    }
    
}
