//
//  CDRoadmap+CoreDataProperties.swift
//  Final Challenge
//
//  Created by Andrea Belcore on 24/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//
//

import Foundation
import CoreData


extension CDRoadmap {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDRoadmap> {
        return NSFetchRequest<CDRoadmap>(entityName: "CDRoadmap")
    }

    @NSManaged public var category: Int16
    @NSManaged public var isPublic: Bool
    @NSManaged public var isShared: Bool
    @NSManaged public var lastReadTimestamp: NSDate?
    @NSManaged public var privileges: Int16
    @NSManaged public var title: String?
    @NSManaged public var visibility: Int16
    @NSManaged public var steps: NSOrderedSet?

}

// MARK: Generated accessors for steps
extension CDRoadmap {

    @objc(insertObject:inStepsAtIndex:)
    @NSManaged public func insertIntoSteps(_ value: CDStep, at idx: Int)

    @objc(removeObjectFromStepsAtIndex:)
    @NSManaged public func removeFromSteps(at idx: Int)

    @objc(insertSteps:atIndexes:)
    @NSManaged public func insertIntoSteps(_ values: [CDStep], at indexes: NSIndexSet)

    @objc(removeStepsAtIndexes:)
    @NSManaged public func removeFromSteps(at indexes: NSIndexSet)

    @objc(replaceObjectInStepsAtIndex:withObject:)
    @NSManaged public func replaceSteps(at idx: Int, with value: CDStep)

    @objc(replaceStepsAtIndexes:withSteps:)
    @NSManaged public func replaceSteps(at indexes: NSIndexSet, with values: [CDStep])

    @objc(addStepsObject:)
    @NSManaged public func addToSteps(_ value: CDStep)

    @objc(removeStepsObject:)
    @NSManaged public func removeFromSteps(_ value: CDStep)

    @objc(addSteps:)
    @NSManaged public func addToSteps(_ values: NSOrderedSet)

    @objc(removeSteps:)
    @NSManaged public func removeFromSteps(_ values: NSOrderedSet)

}
