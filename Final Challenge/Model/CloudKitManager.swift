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
    
    private init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }

    private var container: CKContainer
    private var publicDB: CKDatabase
    private var privateDB: CKDatabase
    
//    func fetchRecord(ckRecordType: String, recordName: String, uuid: UUID) -> CKRecord {
//        /// This func always returns a fetched CKRecord and if this doesn't exist it returns a new one
//        let recordID = CKRecordID(recordName: uuid.uuidString)
//        privateDB.fetch(withRecordID: recordID) { (record, error) in
//            if let error = error {
//                //TO-DO: - Error handling
//                return
//            }
//            if let record = record {
//                return record
//            }
//            
//        }
//    }
    
    func saveRecord(_ record: CKRecord) {
        privateDB.save(record) { (record, error) in
            if let error = error {
                // Error handling
                debugPrint(error.localizedDescription)
                return
            }
            // Successfully saved
            
        }
    }
    
    private func createRecord(recordID: CKRecordID, ckRecordType: String) -> CKRecord {
        let record = CKRecord(recordType: ckRecordType, recordID: recordID)
        
        return record
    }
    
}
