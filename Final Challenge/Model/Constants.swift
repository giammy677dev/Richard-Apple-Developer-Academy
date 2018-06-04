//
//  Constants.swift
//  Final Challenge
//
//  Created by Andrea Belcore on 28/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation

enum K { // swiftlint:disable:this type_name
    static let readingListID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!

    enum CKRecordTypes {
        static let node = "Node"
        static let step = "Step"
        static let roadmap = "Roadmap"

        enum CKNodeRecordField {
            static let url = "url"
            static let title = "title"
            static let uuid = "uuid"
            static let parentUUID = "parentUUID"
            static let tagsData = "tagsData"
            static let text = "text"
            static let propExtracted = "propExtracted"
            static let creationTime = "creationTime"
            static let propRead = "propRead"
            static let propFlagged = "propFlagged"
        }

        enum CKStepRecordField {
            static let title = "title"
            static let parentUUID = "parentUUID"
            static let uuid = "uuid"
        }

        enum CKRoadmapRecordField {
            static let title = "title"
            static let uuid = "uuid"
            static let isPublic = "isPublic"
            static let isShared = "isShared"
            static let visibility = "visibility"
            static let category = "category"
            static let lastReadTimestamp = "lastReadTimestamp"
            static let privileges = "privileges"
            static let steps = "steps"
        }
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
