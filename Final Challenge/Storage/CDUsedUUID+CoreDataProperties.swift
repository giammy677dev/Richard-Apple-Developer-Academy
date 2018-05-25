//
//  CDUsedUUID+CoreDataProperties.swift
//  Final Challenge
//
//  Created by Andrea Belcore on 25/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//
//

import Foundation
import CoreData


extension CDUsedUUID {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUsedUUID> {
        return NSFetchRequest<CDUsedUUID>(entityName: "CDUsedUUID")
    }

    @NSManaged public var uuid: UUID?
    @NSManaged public var toNode: CDNode?
    @NSManaged public var toRoadmap: CDRoadmap?
    @NSManaged public var toStep: CDStep?

}

