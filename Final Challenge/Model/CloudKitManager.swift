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
    var publicDB: CKDatabase
    var privateDB: CKDatabase

    private init() {
        self.container = CKContainer.default()
        self.privateDB = container.privateCloudDatabase
        self.publicDB = container.publicCloudDatabase
    }

    // MARK: - Database operation

    private func addOperationToDB(_ operation: CKDatabaseOperation, database: CKDatabase) {
        database.add(operation)
    }

    // MARK: - Save and delete methods

    /// Saves a record in the Private Database
    func saveRecord(_ record: CKRecord) {
        let savingOperation = CKModifyRecordsOperation()
        savingOperation.recordsToSave = [record]
        savingOperation.savePolicy = .changedKeys // Saves only the changed fields
        savingOperation.modifyRecordsCompletionBlock = self.modifyRecordsCompletionBlock(_:_:_:)
        savingOperation.qualityOfService = .utility

        self.addOperationToDB(savingOperation, database: self.privateDB)
    }

    /// Deletes a record in the Private Database
    func deleteRecord(withRecordID recordID: CKRecordID) {
        let deletionOperation = CKModifyRecordsOperation()
        deletionOperation.recordIDsToDelete = [recordID]
        deletionOperation.savePolicy = .allKeys // force deletion even if the server has a new version of the record
        deletionOperation.modifyRecordsCompletionBlock = self.modifyRecordsCompletionBlock(_:_:_:)
        deletionOperation.qualityOfService = .utility

        self.addOperationToDB(deletionOperation, database: self.privateDB)
    }

    /// The block to execute after the status of all changes is known.
    private func modifyRecordsCompletionBlock(_ savedRecords: [CKRecord]?, _ deletedRecordIDs: [CKRecordID]?, _ operationError: Error?) {
        // This block is executed after all individual progress blocks have completed but before the operation’s completion block.
        // The block is executed serially with respect to the other progress blocks of the operation.

        // TODO: - Handle errors!

    }

    // MARK: - Notifications and DB subscriptions
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
        self.addOperationToDB(saveSubscriptionOperation, database: privateDB)

    }

    func didReceiveRemotePush(notification: [AnyHashable: Any]) {
        // This ckNotification could be useful in future.
        _ = CKNotification(fromRemoteNotificationDictionary: notification)

        handleNotification()

    }

    private func handleNotification() {
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
                }
            }
            guard let changeToken = serverChangeToken else { return }
            let changeTokenData = NSKeyedArchiver.archivedData(withRootObject: changeToken)
            UserDefaults().set(changeTokenData, forKey: K.DefaultsKey.ckServerPrivateDatabaseChangeToken)
        }

        // End of method, adding the fetching operation to the DB.
        fetchOperation.qualityOfService = .utility
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

class CloudKitHelper {

    static let shared: CloudKitHelper = CloudKitHelper()
    private init() {}

    /// Determines if the operation could be retried and the number of seconds to wait.
    private func determineRetry(error: Error) -> Double? {
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

}
