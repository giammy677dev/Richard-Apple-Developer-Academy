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
    
    
    
    private enum RecordNames: String {
        
        case recordZoneName = "Prova"
        
        
    }
    
}
