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
    
    func firstSetup() {
        let readingRoadmap = WritableRoadmap.init(title: "Reading List", category: .other, visibility: .isPrivate, privileges: .isOwner, lastRead: Date(), id: K.readingListRoadmapID)
        let readingStep = Step(title: "Reading List Step", parent: readingRoadmap.uuid, id: K.readingListStepID, index: 0)
        
        self.save(readingRoadmap)
        self.save(readingStep)
    }

    // MARK: Interfaces to save elements simultaneously on CloudKit and on CoreData

    public func save(_ node: Node) {
        /// Saves a node in local and cloud DB. If the node doesn't exist it creates a new one and saves it.
        // MARK: - Save to CloudKit
        let recordID = CKRecordID(recordName: node.uuid.uuidString)
        self.ckManager.privateDB.fetch(withRecordID: recordID) { (record, error) in
            if error != nil {
                //TODO: - Error handling here
                debugPrint(error!.localizedDescription)
            }

            let savedRecord = self.nodeToRecord(record: record, node: node)
            self.ckManager.saveRecord(savedRecord)
        }

        // MARK: - Save to CoreData
        saveToCoreData(node: node)
    }

    public func save(_ roadmap: WritableRoadmap) {
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

        // MARK: - Save to CoreData
        saveToCoreData(roadmap: roadmap)
    }

    /// Saves a step in local and cloud DB. If the step doesn't exist it creates a new one and saves it.
    public func save(_ step: Step) {
        let recordID = CKRecordID(recordName: step.uuid.uuidString)
        self.ckManager.privateDB.fetch(withRecordID: recordID) { (record, error) in
            if error != nil {
                //TODO: - Error handling here
                debugPrint(error!.localizedDescription)
            }

            let savedRecord = self.stepToRecord(record: record, step: step)
            self.ckManager.saveRecord(savedRecord)
        }

        // MARK: - Save to CoreData
        interfaceCDSaveStep(step)
    }

    // MARK: - Save elements in Core Data

    /// Save Roadmap on CoreData
    private func saveToCoreData(roadmap: WritableRoadmap) { //Save single roadmap with steps and nodes
        cdController.saveRecursively(roadmap)
    }

    /// Save an array of Roadmaps on CoreData
    private func saveToCoreData(roadmaps: [WritableRoadmap]) { //Save an array of roadmaps with steps. Nodes must already exist in memory.
        cdController.saveRecursively(roadmaps)
    }

    /// Function to prepare Step saving on CoreData DataBase:
    private func interfaceCDSaveStep(_ step: Step) {
        //Get elements nedded for saving Step
        guard let cdRoadmap = cdController.fetchCDRoadmap(uuid: step.parent) else {
            debugPrint("Error on Roadmap fetching from CoreData!")
            return
        }
        let roadmap = cdController.roadmapFromRecord(cdRoadmap)

        // Call the function to save Step on CoreData
        saveToCoreData(step: step, roadmap: roadmap)
    }

    /// Save Step on CoreData, need an interface:
    private func saveToCoreData(step: Step, roadmap: WritableRoadmap) { //Save a step in memory and link it to a roadmap
        guard let _ = cdController.updateStep(step, of: roadmap) else {
            debugPrint("Error on save step in local memory")
            return
        }
    }

    /// Save Node on CoreData
    private func saveToCoreData(node: Node) { //Save a node in memory
        guard let _ = cdController.updateNode(node) else {
            debugPrint("Error on save node in local memory")
            return
        }
    }

    // MARK: - Interface to deleting operations
    public func deleteRoadmap(_ roadmap: WritableRoadmap) {
        let recordID = CKRecordID(recordName: roadmap.uuid.uuidString)
        cdController.deleteRoadmap(roadmap) //Delete roadmap from CoreData DB
        ckManager.deleteRecord(withRecordID: recordID) //Delete roadmap from CloudKit DB
    }

    public func deleteStep(_ step: Step) {
        let recordID = CKRecordID(recordName: step.uuid.uuidString)
        cdController.deleteStep(step) //Delete step from CoreData DB
        ckManager.deleteRecord(withRecordID: recordID) //Delete step from CloudKit DB
    }

    public func deleteNode(_ node: Node) {
        let recordID = CKRecordID(recordName: node.uuid.uuidString)
        cdController.deleteNode(node) //Delete node from CoreData DB
        ckManager.deleteRecord(withRecordID: recordID) //Delete roadmap from CloudKit DB
    }

    //MAKE: - Load data from Database
    func loadRoadmaps() -> [Roadmap]? {
        return cdController.getFullRoadmapRecords()
    }

    func loadNodes() -> [Node]? {
        return cdController.getEveryNodeRecord()
    }

    // MARK: - To CKRecord methods
    /// When a new record has to be saved it creates a new one otherwise it re-saves all the key-values
    private func roadmapToRecord(record: CKRecord?, roadmap: Roadmap) -> CKRecord {
        if let record = record {
            record.setValue(roadmap.category, forKey: K.CKRecordTypes.CKRoadmapRecordField.category)
            record.setValue(roadmap.isPublic, forKey: K.CKRecordTypes.CKRoadmapRecordField.isPublic)
            record.setValue(roadmap.isShared, forKey: K.CKRecordTypes.CKRoadmapRecordField.isShared)
            record.setValue(roadmap.lastReadTimestamp, forKey: K.CKRecordTypes.CKRoadmapRecordField.lastReadTimestamp)
            record.setValue(roadmap.privileges, forKey: K.CKRecordTypes.CKRoadmapRecordField.privileges)
            record.setValue(roadmap.title, forKey: K.CKRecordTypes.CKRoadmapRecordField.title)
            record.setValue(roadmap.uuid, forKey: K.CKRecordTypes.CKRoadmapRecordField.uuid)
            record.setValue(roadmap.visibility, forKey: K.CKRecordTypes.CKRoadmapRecordField.visibility)
        }

        let recordID = CKRecordID(recordName: roadmap.uuid.uuidString)
        let newRecord = CKRecord(recordType: K.CKRecordTypes.roadmap, recordID: recordID)

        newRecord.setValue(roadmap.category, forKey: K.CKRecordTypes.CKRoadmapRecordField.category)
        newRecord.setValue(roadmap.isPublic, forKey: K.CKRecordTypes.CKRoadmapRecordField.isPublic)
        newRecord.setValue(roadmap.isShared, forKey: K.CKRecordTypes.CKRoadmapRecordField.isShared)
        newRecord.setValue(roadmap.lastReadTimestamp, forKey: K.CKRecordTypes.CKRoadmapRecordField.lastReadTimestamp)
        newRecord.setValue(roadmap.privileges, forKey: K.CKRecordTypes.CKRoadmapRecordField.privileges)
        newRecord.setValue(roadmap.title, forKey: K.CKRecordTypes.CKRoadmapRecordField.title)
        newRecord.setValue(roadmap.uuid, forKey: K.CKRecordTypes.CKRoadmapRecordField.uuid)
        newRecord.setValue(roadmap.visibility, forKey: K.CKRecordTypes.CKRoadmapRecordField.visibility)

        return newRecord
    }

    /// When a new record has to be saved it creates a new one otherwise it re-saves all the key-values
    private func stepToRecord(record: CKRecord?, step: Step) -> CKRecord {
        if let record = record {

            record.setValue(step.title, forKey: K.CKRecordTypes.CKStepRecordField.title)
            record.setValue(step.indexInParent, forKeyPath: K.CKRecordTypes.CKStepRecordField.indexInParent)

            // Set the reference to the parent and the delete cascade update policy
            let parentID = CKRecordID(recordName: step.parent.uuidString)
            let parentReference = CKReference(recordID: parentID, action: .none)
            record.parent = parentReference

            return record
        }

        let recordID = CKRecordID(recordName: step.uuid.uuidString)
        let newRecord = CKRecord(recordType: K.CKRecordTypes.step, recordID: recordID)

        newRecord.setValue(step.title, forKey: K.CKRecordTypes.CKStepRecordField.title)
        newRecord.setValue(step.indexInParent, forKeyPath: K.CKRecordTypes.CKStepRecordField.indexInParent)

        // Set the reference to the parent
        let parentID = CKRecordID(recordName: step.parent.uuidString)
        let parentReference = CKReference(recordID: parentID, action: CKReferenceAction.none)
        newRecord.parent = parentReference

        return newRecord
    }

    /// When a new record has to be saved it creates a new one otherwise it re-saves all the key-values
    private func nodeToRecord(record: CKRecord?, node: Node) -> CKRecord {
        // Encoding not supported data types
        let encoder = PropertyListEncoder()
        let tagsData = try? encoder.encode(node.tags)

        // Set the reference to the parent
        let parentID = CKRecordID(recordName: node.parent.uuidString)
        let parentReference = CKReference(recordID: parentID, action: CKReferenceAction.none)

        // If the record already exists (and it has been fetched)
        if let record = record {
            record.setValue(node.creationTimestamp, forKey: K.CKRecordTypes.CKNodeRecordField.creationTime)
            record.setValue(node.extractedText, forKey: K.CKRecordTypes.CKNodeRecordField.text)
            record.setValue(node.isFlagged, forKey: K.CKRecordTypes.CKNodeRecordField.propFlagged)
            record.setValue(node.isRead, forKey: K.CKRecordTypes.CKNodeRecordField.propRead)
            record.setValue(node.isTextProperlyExtracted, forKey: K.CKRecordTypes.CKNodeRecordField.propExtracted)
            record.setValue(node.title, forKey: K.CKRecordTypes.CKNodeRecordField.title)
            record.setValue(node.url.absoluteString, forKey: K.CKRecordTypes.CKNodeRecordField.urlString)
            record.setValue(node.indexInParent, forKeyPath: K.CKRecordTypes.CKNodeRecordField.indexInParent)

            record.setValue(tagsData, forKey: K.CKRecordTypes.CKNodeRecordField.tagsData)
            record.parent = parentReference

            return record
        }

        // Else
        let recordID = CKRecordID(recordName: node.uuid.uuidString)
        let newRecord = CKRecord(recordType: K.CKRecordTypes.node, recordID: recordID)

        newRecord.setValue(node.creationTimestamp, forKey: K.CKRecordTypes.CKNodeRecordField.creationTime)
        newRecord.setValue(node.extractedText, forKey: K.CKRecordTypes.CKNodeRecordField.text)
        newRecord.setValue(node.isFlagged, forKey: K.CKRecordTypes.CKNodeRecordField.propFlagged)
        newRecord.setValue(node.isRead, forKey: K.CKRecordTypes.CKNodeRecordField.propRead)
        newRecord.setValue(node.isTextProperlyExtracted, forKey: K.CKRecordTypes.CKNodeRecordField.propExtracted)
        newRecord.setValue(node.title, forKey: K.CKRecordTypes.CKNodeRecordField.title)
        newRecord.setValue(node.url.absoluteString, forKey: K.CKRecordTypes.CKNodeRecordField.urlString)
        newRecord.setValue(node.indexInParent, forKeyPath: K.CKRecordTypes.CKNodeRecordField.indexInParent)

        newRecord.setValue(tagsData, forKey: K.CKRecordTypes.CKNodeRecordField.tagsData)
        newRecord.parent = parentReference

        return newRecord
    }

    // MARK: - From CKRecord methods
    private func recordToStep(_ ckRecord: CKRecord) -> Step? {
        guard let stepTitle = ckRecord[K.CKRecordTypes.CKStepRecordField.title] as? String,
            let stepParentID = ckRecord[K.CKRecordTypes.CKStepRecordField.parentUUID] as? String,
            let stepParentUUID = UUID(uuidString: stepParentID),
            let stepUUID = UUID(uuidString: ckRecord.recordID.recordName),
            let indexInParent = ckRecord[K.CKRecordTypes.CKStepRecordField.indexInParent] as? Int
            else { return nil }

        let step = Step(title: stepTitle, parent: stepParentUUID, id: stepUUID, index: indexInParent)
        return step
    }

    private func recordToRoadmap(_ ckRecord: CKRecord) -> WritableRoadmap? {
        guard
            let title = ckRecord[K.CKRecordTypes.CKRoadmapRecordField.title] as? String,
            let categoryID = ckRecord[K.CKRecordTypes.CKRoadmapRecordField.category] as? Int16,
            let visibilityID = ckRecord[K.CKRecordTypes.CKRoadmapRecordField.visibility] as? Int16,
            let privilegesID = ckRecord[K.CKRecordTypes.CKRoadmapRecordField.privileges] as? Int16,
            let lastRead = ckRecord[K.CKRecordTypes.CKRoadmapRecordField.lastReadTimestamp] as? Date,
            let uuid = UUID(uuidString: ckRecord.recordID.recordName),
            let visibility = RoadmapVisibility(rawValue: visibilityID),
            let category = Category(rawValue: categoryID),
            let privileges = UserPrivilege(rawValue: privilegesID)

            else { return nil }

        let roadmap = WritableRoadmap(title: title, category: category, visibility: visibility, privileges: privileges, lastRead: lastRead, id: uuid)
        return roadmap
    }

    private func recordToNode(_ ckRecord: CKRecord) -> Node? {
        guard
            let title = ckRecord[K.CKRecordTypes.CKNodeRecordField.title] as? String,
            let uuid = UUID(uuidString: ckRecord.recordID.recordName),
            let text = ckRecord[K.CKRecordTypes.CKNodeRecordField.text] as? String,
            let propExtracted = ckRecord[K.CKRecordTypes.CKNodeRecordField.propExtracted] as? Bool,
            let creationTime = ckRecord[K.CKRecordTypes.CKNodeRecordField.creationTime] as? Date,
            let propRead = ckRecord[K.CKRecordTypes.CKNodeRecordField.propRead] as? Bool,
            let propFlagged = ckRecord[K.CKRecordTypes.CKNodeRecordField.propFlagged] as? Bool,
            let parentUUIDString = ckRecord[K.CKRecordTypes.CKNodeRecordField.parentUUID] as? String,
            let parentUUID = UUID(uuidString: parentUUIDString),
            let urlString = ckRecord[K.CKRecordTypes.CKNodeRecordField.urlString] as? String,
            let url = URL(string: urlString),
            let indexInParent = ckRecord[K.CKRecordTypes.CKNodeRecordField.indexInParent] as? Int
            else { return nil }

        var tagsSet: Set<String>?
        if let tagsData = ckRecord[K.CKRecordTypes.CKNodeRecordField.tagsData] as? Data {
            let decoder = PropertyListDecoder()
            tagsSet = try? decoder.decode(Set<String>.self, from: tagsData)
        }

        let node = Node(url: url, title: title, id: uuid, parent: parentUUID, tags: tagsSet, text: text, propExtracted: propExtracted, creationTime: creationTime, propRead: propRead, propFlagged: propFlagged, index: indexInParent)

        return node
    }

    func createUniqueUUID() -> UUID {
        var uuid: UUID

        repeat {
            uuid = UUID()
        } while (cdController.isUUIDInUse(uuid))

        return uuid
    }

    func recordChanged(_ ckRecord: CKRecord) {
        // The block to execute with the contents of a changed record.
        switch ckRecord.recordType {
        case K.CKRecordTypes.node: updateNode(fromRecord: ckRecord)
        case K.CKRecordTypes.step: updateStep(fromRecord: ckRecord)
        case K.CKRecordTypes.roadmap: updateRoadmap(fromRecord: ckRecord)
        default: return
        }
    }

    private func updateNode(fromRecord ckRecord: CKRecord) {
        // TODO: - Update Node
        guard let node = self.recordToNode(ckRecord) else { return }
        _ = cdController.updateNode(node)
    }

    private func updateStep(fromRecord ckRecord: CKRecord) {
        guard let step = self.recordToStep(ckRecord) else { return }
        _ = cdController.updateStep(step, of: step.parent)
    }

    private func updateRoadmap(fromRecord ckRecord: CKRecord) {
        guard let roadmap = self.recordToRoadmap(ckRecord) else { return }
        _ = cdController.updateRoadmap(roadmap)
    }

    func recordDeleted(withID recordID: CKRecordID, recordType: String) {
        // The block to execute with the ID of a record that was deleted.
        guard let uuid = UUID(uuidString: recordID.recordName) else { return }
        switch recordType {
        case K.CKRecordTypes.node: CoreDataController.shared.deleteNode(uuid)
        case K.CKRecordTypes.step: CoreDataController.shared.deleteStep(uuid)
        case K.CKRecordTypes.roadmap: CoreDataController.shared.deleteRoadmap(uuid)
        default: return
        }
    }

}
