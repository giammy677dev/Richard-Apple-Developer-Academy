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
    
    func fetchRecord(ckRecordType: String, recordName: String) -> CKRecord? {
        /// This func always returns a fetched CKRecord and if this doesn't exist it returns a new one
        
        return nil
    }
    
    func saveRecord(_ record: CKRecord) {
        publicDB.save(record) { (record, error) in
            if let error = error {
                // Error handling
                debugPrint(error.localizedDescription)
                return
            }
            // Successfully saved
            
        }
    }
    
    private func createRecord(){}
    
}
