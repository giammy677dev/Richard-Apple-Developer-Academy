//
//  Constants.swift
//  Final Challenge
//
//  Created by Andrea Belcore on 28/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation

enum K {
    static let readingListID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!

    enum CKRecordTypes {
        static let node = "Node"
        static let step = "Step"
        static let roadmap = "Roadmap"
    }

    enum CKQuerySubscriptionID {
        static let nodeCreation = "nodeCreation"
        static let nodeUpdate = "nodeUpdate"
        static let nodeDeletion = "nodeDeletion"

        static let stepCreation = "stepCreation"
        static let stepUpdate = "stepUpdate"
        static let stepDeletion = "stepDeletion"

        static let roadmapCreation = "roadmapCreation"
        static let roadmapUpdate = "roadmapUpdate"
        static let roadmapDeletion = "roadmapDeletion"
    }

    enum DefaultsKey {
        static let hasLaunchedBefore = "hasLaunchedBefore"
        static let ckSubscriptionSetupDone = "ckSubscriptionSetupDone"
        static let ckServerPrivateDatabaseChangeToken = "ckServerPrivateDatabaseChangeToken"
        static let ckServerRecordZoneChangeTokenWithID = "ckServerRecordZoneChangeTokenWithID"  // Use this only with an appended recordZoneID.zoneName
    }
}
