//
//  CloudKitManager.swift
//  Final Challenge
//
//  Created by Stefano Formicola on 23/05/2018.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation
import CloudKit

final class CloudKitManager {
    
    static let shared = CloudKitManager()
    
    private var container: CKContainer
    var publicDB: CKDatabase {
        get {
            return container.publicCloudDatabase
        }
    }
    var privateDB: CKDatabase {
        get {
            return container.privateCloudDatabase
        }
    }
    
    private init() {
        container = CKContainer.default()
    }

    
//    func fetchRecord(ckRecordType: String, recordName: String, uuid: UUID) -> CKRecord {
//        /// This func always returns a fetched CKRecord and if this doesn't exist it returns a new one
//        let recordID = CKRecordID(recordName: uuid.uuidString)
//        privateDB.fetch(withRecordID: recordID) { (record, error) in
//            //TO-DO: - Error handling
//            if let _ = error {
//                debugPrint(error!.localizedDescription)
//                let newRecord = self.createRecord(recordID: recordID, ckRecordType: ckRecordType)
//                return newRecord
//            } else {
//
//            }
//        }
//        privateDB.fetch(withRecordID: <#T##CKRecordID#>, completionHandler: <#T##(CKRecord?, Error?) -> Void#>)
//
//    }
    
    func saveRecord(_ record: CKRecord) {
        privateDB.save(record) { (record, error) in
            if let error = error {
                //TO-DO: - Error handling
                debugPrint(error.localizedDescription)
                return
            }
            // Successfully saved
            
        }
    }
    
    //MARK: - Functions for deleting operations
    
    func deleteRoadmap(_ roadmapID: CKRecordID) {
        privateDB.delete(withRecordID: roadmapID) { (recordID, error) in
            if let err = error {
                //TO-DO: - Error handling
                debugPrint(err.localizedDescription)
                return
            } else {
                debugPrint("Succesfully deleted roadmap with id: \(String(describing: recordID))")
            }
        }
    }
    
    func deleteStep(_ stepID: CKRecordID) {
        privateDB.delete(withRecordID: stepID) { (recordID, error) in
            if let err = error {
                //TO-DO: - Error handling
                debugPrint(err.localizedDescription)
                return
            } else {
                debugPrint("Succesfully deleted step with id: \(String(describing: recordID))")
            }
        }
    }
    
    func deleteNode(_ nodeID: CKRecordID) {
        privateDB.delete(withRecordID: nodeID) { (recordID, error) in
            if let err = error {
                //TO-DO: - Error handling
                debugPrint(err.localizedDescription)
                return
            } else {
                debugPrint("Succesfully deleted node with id: \(String(describing: recordID))")
            }
        }
    }
    
    //MARK: - Create Record
    private func createRecord(recordID: CKRecordID, ckRecordType: String) -> CKRecord {
        let record = CKRecord(recordType: ckRecordType, recordID: recordID)
        
        return record
    }
    
}
