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
    
    func subscriptionSetup() {
        let defaults = UserDefaults()
        let hasLaunchedBefore = defaults.bool(forKey: "subscriptionSetupDone")
        
        guard !hasLaunchedBefore else { defaults.set(true, forKey: "subscriptionSetupDone"); return }
        
        debugPrint("first launch setup of cloudkit manager")
        // Init the subscription
        let privateDBSubscription = CKDatabaseSubscription(subscriptionID: "PrivateDBSubscription")
        // Silent push notifications won't alert the user
        let notificationInfo = CKNotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        privateDBSubscription.notificationInfo = notificationInfo
        // Saving the subscription
        privateDB.save(privateDBSubscription) { (subscription, error) in
            if let error = error {
                //WARNING: - Error handling here
                debugPrint(error)
            }
        }
    }
    
    func didReceiveRemotePush(notification: [AnyHashable : Any]) {
        let ckNotification = CKNotification(fromRemoteNotificationDictionary: notification)
        
        
    }
    
    //MARK: - Create Record
    private func createRecord(recordID: CKRecordID, ckRecordType: String) -> CKRecord {
        let record = CKRecord(recordType: ckRecordType, recordID: recordID)
        
        return record
    }
    
}
