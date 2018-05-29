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
    
    
    //MARK: - Notifications and DB subscriptions
    func subscriptionSetup() {
        let defaults = UserDefaults()
        let hasLaunchedBefore = defaults.bool(forKey: K.DefaultsKey.ckSubscriptionSetupDone)
        
        guard !hasLaunchedBefore else { return }
        
        debugPrint("first launch setup of cloudkit manager")
        
        // Init the subscriptions
        let truePredicate = NSPredicate(value: true)
        
        var subscriptionsArray = [
            // Roadmaps
            CKQuerySubscription(recordType: K.CKRecordTypes.roadmap, predicate: truePredicate, subscriptionID: K.CKQuerySubscriptionID.roadmapCreation, options: .firesOnRecordCreation),
            CKQuerySubscription(recordType: K.CKRecordTypes.roadmap, predicate: truePredicate, subscriptionID: K.CKQuerySubscriptionID.roadmapDeletion, options: .firesOnRecordDeletion),
            CKQuerySubscription(recordType: K.CKRecordTypes.roadmap, predicate: truePredicate, subscriptionID: K.CKQuerySubscriptionID.roadmapUpdate, options: .firesOnRecordUpdate),
            // Steps
            CKQuerySubscription(recordType: K.CKRecordTypes.step, predicate: truePredicate, subscriptionID: K.CKQuerySubscriptionID.stepCreation, options: .firesOnRecordCreation),
            CKQuerySubscription(recordType: K.CKRecordTypes.step, predicate: truePredicate, subscriptionID: K.CKQuerySubscriptionID.stepDeletion, options: .firesOnRecordDeletion),
            CKQuerySubscription(recordType: K.CKRecordTypes.step, predicate: truePredicate, subscriptionID: K.CKQuerySubscriptionID.stepUpdate, options: .firesOnRecordUpdate),
            // Nodes
            CKQuerySubscription(recordType: K.CKRecordTypes.node, predicate: truePredicate, subscriptionID: K.CKQuerySubscriptionID.nodeCreation, options: .firesOnRecordCreation),
            CKQuerySubscription(recordType: K.CKRecordTypes.node, predicate: truePredicate, subscriptionID: K.CKQuerySubscriptionID.nodeDeletion, options: .firesOnRecordDeletion),
            CKQuerySubscription(recordType: K.CKRecordTypes.node, predicate: truePredicate, subscriptionID: K.CKQuerySubscriptionID.nodeUpdate, options: .firesOnRecordUpdate)
        ]
        
        // Silent push notifications won't alert the user
        let notificationInfo = CKNotificationInfo()
        notificationInfo.shouldSendContentAvailable = true

        subscriptionsArray = subscriptionsArray.map({
            debugPrint($0.debugDescription)
            $0.notificationInfo = notificationInfo
            return $0
        })
        
        let saveSubscriptionOperation = CKModifySubscriptionsOperation(subscriptionsToSave: subscriptionsArray, subscriptionIDsToDelete: nil)
        saveSubscriptionOperation.modifySubscriptionsCompletionBlock = { (_, _, error) in
            guard error == nil else {
                return
            }
            // Subscription done. Set the defaults key to true
            defaults.set(true, forKey: K.DefaultsKey.ckSubscriptionSetupDone)
        }
        // Add a specific QoS and Queue priority
        saveSubscriptionOperation.qualityOfService = .utility
        
        // Saving the subscription
        privateDB.add(saveSubscriptionOperation)
        
        
    }
    
    func didReceiveRemotePush(notification: [AnyHashable : Any]) {
        let ckNotification = CKNotification(fromRemoteNotificationDictionary: notification)
        
        
    }
    
    func handleNotification(_ notification: CKNotification) {
        // Handle receipt of an incoming push notification that something has changed
        
    }
    
    
    
    //MARK: - Create Record
    private func createRecord(recordID: CKRecordID, ckRecordType: String) -> CKRecord {
        let record = CKRecord(recordType: ckRecordType, recordID: recordID)
        
        return record
    }
    
}
