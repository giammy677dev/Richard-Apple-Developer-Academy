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
    @NSManaged public var uuid: UUID?
    @NSManaged public var stepsList: NSOrderedSet?

}

// MARK: Generated accessors for stepsList
extension CDRoadmap {

    @objc(insertObject:inStepsListAtIndex:)
    @NSManaged public func insertIntoStepsList(_ value: CDStep, at idx: Int)

    @objc(removeObjectFromStepsListAtIndex:)
    @NSManaged public func removeFromStepsList(at idx: Int)

    @objc(insertStepsList:atIndexes:)
    @NSManaged public func insertIntoStepsList(_ values: [CDStep], at indexes: NSIndexSet)

    @objc(removeStepsListAtIndexes:)
    @NSManaged public func removeFromStepsList(at indexes: NSIndexSet)

    @objc(replaceObjectInStepsListAtIndex:withObject:)
    @NSManaged public func replaceStepsList(at idx: Int, with value: CDStep)

    @objc(replaceStepsListAtIndexes:withStepsList:)
    @NSManaged public func replaceStepsList(at indexes: NSIndexSet, with values: [CDStep])

    @objc(addStepsListObject:)
    @NSManaged public func addToStepsList(_ value: CDStep)

    @objc(removeStepsListObject:)
    @NSManaged public func removeFromStepsList(_ value: CDStep)

    @objc(addStepsList:)
    @NSManaged public func addToStepsList(_ values: NSOrderedSet)

    @objc(removeStepsList:)
    @NSManaged public func removeFromStepsList(_ values: NSOrderedSet)

}

