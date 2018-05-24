//
//  CDNode+CoreDataProperties.swift
//  Final Challenge
//
//  Created by Andrea Belcore on 24/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//
//

import Foundation
import CoreData


extension CDNode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDNode> {
        return NSFetchRequest<CDNode>(entityName: "CDNode")
    }

    @NSManaged public var creationTimestamp: NSDate?
    @NSManaged public var extractedText: String?
    @NSManaged public var isTextProperlyExtracted: Bool
    @NSManaged public var readingTimeInMinutes: Int32
    @NSManaged public var tags: [NSString]?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var uuid: UUID?

}
