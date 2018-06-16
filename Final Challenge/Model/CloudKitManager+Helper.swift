//
//  CloudKitManager.swift
//  Final Challenge
//
//  Created by Stefano Formicola on 23/05/2018.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

final class CloudKitManager {

    static let shared = CloudKitManager()

    let container: CKContainer = {
        return CKContainer.default()
    }()
    var publicDB: CKDatabase
    var privateDB: CKDatabase

    private init() {
        self.privateDB = container.privateCloudDatabase
        self.publicDB = container.publicCloudDatabase
    }

    // MARK: - Database operation

    private func addOperationToDB(_ operation: CKDatabaseOperation, database: CKDatabase) {
        database.add(operation)
    }

    // MARK: - Save, fetch and delete methods

    /// Saves a record in the Private Database
    func saveRecord(_ record: CKRecord) {
        let savingOperation = CKModifyRecordsOperation()
        savingOperation.recordsToSave = [record]
        savingOperation.savePolicy = .allKeys // Saves only the changed fields
        savingOperation.modifyRecordsCompletionBlock = self.modifyRecordsCompletionBlock(_:_:_:)
        savingOperation.configuration.qualityOfService = .utility
        savingOperation.queuePriority = .veryHigh
        savingOperation.configuration.isLongLived = true

        self.addOperationToDB(savingOperation, database: self.privateDB)
    }

    /// Deletes a record in the Private Database
    func deleteRecord(withRecordID recordID: CKRecordID) {
        let deletionOperation = CKModifyRecordsOperation()
        deletionOperation.recordIDsToDelete = [recordID]
        deletionOperation.savePolicy = .allKeys // force deletion even if the server has a new version of the record
        deletionOperation.modifyRecordsCompletionBlock = self.modifyRecordsCompletionBlock(_:_:_:)
        deletionOperation.configuration.qualityOfService = .utility
        deletionOperation.queuePriority = .veryHigh
        deletionOperation.configuration.isLongLived = true

        self.addOperationToDB(deletionOperation, database: self.privateDB)
    }

    /// Fetches records from a CKDatabase with a recordID specified in the array passed as argument, then a completion handler processes the results.
    func fetchRecordsWithCompletion(recordIDs: [CKRecordID], database: CKDatabase, completionBlock: @escaping (([CKRecordID: CKRecord]?, Error?) -> Void)) {
        let fetchOperation = CKFetchRecordsOperation(recordIDs: recordIDs)
        fetchOperation.configuration.qualityOfService = .utility
        fetchOperation.queuePriority = .veryHigh
        fetchOperation.configuration.isLongLived = true

        fetchOperation.fetchRecordsCompletionBlock = {
            (recordsDict, error) in
            if let fetchingError = error {
                if let waitingSeconds = CloudKitHelper.shared.determineRetry(error: fetchingError) {
                    CloudKitHelper.shared.retryOperation(seconds: waitingSeconds, closure: {
                        self.addOperationToDB(fetchOperation, database: database)
                    })
                }
                if let ckError = fetchingError as? CKError {
                    switch ckError.code {
                    case .partialFailure:
                        completionBlock(recordsDict, fetchingError)
                    default: return
                    }
                }
            } else {
                guard recordsDict != nil else { debugPrint("recordsDict is nil."); return }
                completionBlock(recordsDict, nil)
            }
        }

        self.addOperationToDB(fetchOperation, database: database)
    }

    /// The block to execute after the status of all changes is known.
    private func modifyRecordsCompletionBlock(_ savedRecords: [CKRecord]?, _ deletedRecordIDs: [CKRecordID]?, _ operationError: Error?) {
        // This block is executed after all individual progress blocks have completed but before the operation’s completion block.
        // The block is executed serially with respect to the other progress blocks of the operation.

        if let error = operationError {
            guard let waitingSeconds = CloudKitHelper.shared.determineRetry(error: error) else { return }
            let operationToRetry = CKModifyRecordsOperation(recordsToSave: savedRecords, recordIDsToDelete: deletedRecordIDs)
            operationToRetry.modifyRecordsCompletionBlock = self.modifyRecordsCompletionBlock(_:_:_:)
            DispatchQueue.global().asyncAfter(deadline: .now() + waitingSeconds) {
                self.addOperationToDB(operationToRetry, database: self.privateDB)
            }
        }

    }

    // MARK: - Notifications and DB subscriptions
    func subscriptionSetup() {
        let defaults = UserDefaults()
        let hasLaunchedBefore = defaults.bool(forKey: K.DefaultsKey.ckSubscriptionSetupDone)

        guard !hasLaunchedBefore else { return }

        debugPrint("First launch setup of cloudkit manager")

        // Init the subscriptions
        let truePredicate = NSPredicate(value: true)

        let subscriptionsArray = [
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

        subscriptionsArray.forEach { (querySubscription) in
            querySubscription.notificationInfo = notificationInfo
        }

        let saveSubscriptionOperation = CKModifySubscriptionsOperation(subscriptionsToSave: subscriptionsArray, subscriptionIDsToDelete: nil)
        // Operation properties
        saveSubscriptionOperation.configuration.qualityOfService = .utility
        saveSubscriptionOperation.queuePriority = .veryHigh
        saveSubscriptionOperation.configuration.isLongLived = true

        // Subscription completion handler
        saveSubscriptionOperation.modifySubscriptionsCompletionBlock = { (_, _, error) in
            if let error = error {
                guard let waitingTime = CloudKitHelper.shared.determineRetry(error: error) else { debugPrint("Couldn't determine the error when saving the subscription"); return }
                CloudKitHelper.shared.retryOperation(seconds: waitingTime, closure: {
                    // Retry
                    self.addOperationToDB(saveSubscriptionOperation, database: self.privateDB)
                })
            } else {
                // Subscription done. Sets the defaults key to true and starts fetching
                defaults.set(true, forKey: K.DefaultsKey.ckSubscriptionSetupDone)

                self.handleNotification(applicationCompletionBlock: { _ in })
            }
        }

        // Subscribing
        self.addOperationToDB(saveSubscriptionOperation, database: privateDB)
    }

    func didReceiveRemotePush(notification: [AnyHashable: Any], completion: @escaping (UIBackgroundFetchResult) -> Void) {
        // This ckNotification could be useful in future.
        _ = CKNotification(fromRemoteNotificationDictionary: notification)

        self.handleNotification(applicationCompletionBlock: completion)

    }

    private func handleNotification(applicationCompletionBlock: @escaping (UIBackgroundFetchResult) -> Void) {
        // Use the CKServerChangeToken to fetch only whatever changes have occurred since the last
        // time we asked, since intermediate push notifications might have been dropped.
        var changeToken: CKServerChangeToken?
        let changeTokenData = UserDefaults().data(forKey: K.DefaultsKey.ckServerPrivateDatabaseChangeToken)
        if let changeTokenData = changeTokenData {
            changeToken = NSKeyedUnarchiver.unarchiveObject(with: changeTokenData) as? CKServerChangeToken
        }
        // Init the fetching operation
        let fetchOperation = CKFetchDatabaseChangesOperation(previousServerChangeToken: changeToken)
        fetchOperation.fetchAllChanges = true

        // Setting the blocks to process the operation results
        fetchOperation.changeTokenUpdatedBlock = { (serverToken) in
            // The block to execute when the change token has changed.
            let changeTokenData = NSKeyedArchiver.archivedData(withRootObject: serverToken)
            UserDefaults().set(changeTokenData, forKey: K.DefaultsKey.ckServerPrivateDatabaseChangeToken)
            // It makes sense that if the server token has changed the app needs to fetch new data.
            applicationCompletionBlock(.newData)
        }

        fetchOperation.recordZoneWithIDChangedBlock = { (recordZoneID) in
            // The block that processes a single record zone change.
            self.fetchChangedRecordZoneWithID(recordZoneID)
        }

        fetchOperation.recordZoneWithIDWasDeletedBlock = { (recordZoneID) in
            // The block that processes a single record zone deletion.
            self.fetchDeletedRecordZoneWithID(recordZoneID)
        }

        fetchOperation.recordZoneWithIDWasPurgedBlock = { (recordZoneID) in
            // The block that processes a single record zone purge.
            self.fetchPurgedRecordZoneWithID(recordZoneID)
        }

        fetchOperation.fetchDatabaseChangesCompletionBlock = { (serverChangeToken, _, operationError) in
            // The block to execute when the operation completes.
            if let error = operationError as? CKError {
                if error.code == CKError.Code.changeTokenExpired {
                    // The CKServerChangeToken is no longer valid and must be resynced.
                    UserDefaults().set(nil, forKey: K.DefaultsKey.ckServerPrivateDatabaseChangeToken)
                    // The fetching will restart and the application needs to be notified.
                    self.handleNotification(applicationCompletionBlock: applicationCompletionBlock)
                }
            }
            guard let changeToken = serverChangeToken else { return }
            let changeTokenData = NSKeyedArchiver.archivedData(withRootObject: changeToken)
            UserDefaults().set(changeTokenData, forKey: K.DefaultsKey.ckServerPrivateDatabaseChangeToken)
        }

        // Operation properties
        fetchOperation.configuration.qualityOfService = .utility
        fetchOperation.queuePriority = .veryHigh
        fetchOperation.configuration.isLongLived = true

        self.addOperationToDB(fetchOperation, database: privateDB)
    }

    private func fetchChangedRecordZoneWithID(_ recordZoneID: CKRecordZoneID) {
        // Use the CKServerChangeToken to fetch only whatever changes have occurred since the last
        // time we asked, since intermediate push notifications might have been dropped.
        var changeTokenKey = K.DefaultsKey.ckServerRecordZoneChangeTokenWithID
        changeTokenKey.append(recordZoneID.zoneName)

        let changeTokenData = UserDefaults().data(forKey: changeTokenKey)
        var changeToken: CKServerChangeToken?
        if changeTokenData != nil {
            changeToken = NSKeyedUnarchiver.unarchiveObject(with: changeTokenData!) as? CKServerChangeToken
        }
        let options = CKFetchRecordZoneChangesOptions()
        options.previousServerChangeToken = changeToken
        let optionsMap = [recordZoneID: options]

        let fetchChangesOperation = CKFetchRecordZoneChangesOperation(recordZoneIDs: [recordZoneID], optionsByRecordZoneID: optionsMap)
        fetchChangesOperation.fetchAllChanges = true

        // Manage a record update or record deletion
        fetchChangesOperation.recordChangedBlock = DatabaseInterface.shared.recordChanged(_:)
        fetchChangesOperation.recordWithIDWasDeletedBlock = DatabaseInterface.shared.recordDeleted(withID:recordType:)

        fetchChangesOperation.recordZoneChangeTokensUpdatedBlock = { (_, serverChangeToken, clientChangeTokenData) in
            //FIXME: - Check if the server token is equal to the client token
            guard let serverChangeToken = serverChangeToken else { return }
            let changeTokenData = NSKeyedArchiver.archivedData(withRootObject: serverChangeToken)
            UserDefaults().set(changeTokenData, forKey: changeTokenKey)
        }

        fetchChangesOperation.recordZoneFetchCompletionBlock = { (_, serverChangeToken, clientChangeTokenData, _, error) in
            // The block to execute when the fetch for a zone has completed.
            guard error == nil else { return }
            guard let changeToken = serverChangeToken else { return }
            //FIXME: - Check if the server token is equal to the client token
            let changeTokenData = NSKeyedArchiver.archivedData(withRootObject: changeToken)
            UserDefaults().set(changeTokenData, forKey: changeTokenKey)
        }

        fetchChangesOperation.fetchRecordZoneChangesCompletionBlock = { error in
            guard let error = error as? CKError else { return }
            if error.code == CKError.Code.changeTokenExpired {
                // The CKServerChangeToken is no longer valid and must be resynced.
                UserDefaults().set(nil, forKey: changeTokenKey)
            }
        }

        // End of method, adding the fetching operation to the DB.
        fetchChangesOperation.qualityOfService = .utility
        fetchChangesOperation.queuePriority = .veryHigh
        fetchChangesOperation.configuration.isLongLived = true
        self.addOperationToDB(fetchChangesOperation, database: privateDB)
    }

    private func fetchDeletedRecordZoneWithID(_ recordZoneID: CKRecordZoneID) {}
    private func fetchPurgedRecordZoneWithID(_ recordZoneID: CKRecordZoneID) {}

    // MARK: - Create Record
    private func createRecord(recordID: CKRecordID, ckRecordType: String) -> CKRecord {
        let record = CKRecord(recordType: ckRecordType, recordID: recordID)

        return record
    }

}

/// Singleton class used to manage CloudKit errors and exceptions
final class CloudKitHelper {

    static let shared: CloudKitHelper = CloudKitHelper()
    private init() {}

    /// Determines if the operation could be retried and the number of seconds to wait.
    func determineRetry(error: Error) -> Double? {
        if let ckError = error as? CKError {
            switch ckError {
            case CKError.requestRateLimited, CKError.serviceUnavailable, CKError.zoneBusy, CKError.networkFailure:
                let retry = ckError.retryAfterSeconds ?? 3.0
                return retry
            default:
                return nil
            }
        } else {
            // Found on internet, it's an error that occurs when there's no connection or couldn't connect to the CloudKit database. It is suggested to wait 6 seconds.
            let nsError = error as NSError
            if nsError.domain == NSCocoaErrorDomain {
                if nsError.code == 4097 {
                    debugPrint("CloudKit is dead. I'm going to retry after 6 seconds.")

                    return 6.0
                }
            }
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }

        return nil
    }

    /// Dispatches the same operation on the global queue after some time in seconds
    func retryOperation(seconds: Double, closure: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + seconds) {
            closure()
        }
    }

    func retryLongLivedOperations() {
        let ckContainer = CloudKitManager.shared.container

        ckContainer.fetchAllLongLivedOperationIDs { (operationsByIDs, error) in
            if let error = error {
                debugPrint("Error fetching long lived operations: \(error)")
                return
            }
            guard let identifiers = operationsByIDs else { return }
            for operationID in identifiers {
                ckContainer.fetchLongLivedOperation(withID: operationID, completionHandler: { (operation, error) in
                    if let error = error {
                        debugPrint("Error fetching operation \(operationID): \(error.localizedDescription)")
                        return
                    }
                    guard let operation = operation else { return }
                    // Callback handlers
                    operation.completionBlock = {}
                    ckContainer.add(operation)
                })
            }
        }
    }

}
