//
//  CDStep+CoreDataProperties.swift
//  Final Challenge
//
//  Created by Andrea Belcore on 24/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//
//

import Foundation
import CoreData


extension CDStep {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDStep> {
        return NSFetchRequest<CDStep>(entityName: "CDStep")
    }

    @NSManaged public var arrayID: Int64
    @NSManaged public var title: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var nodes: NSOrderedSet?

}

// MARK: Generated accessors for nodes
extension CDStep {

    @objc(insertObject:inNodesAtIndex:)
    @NSManaged public func insertIntoNodes(_ value: CDNode, at idx: Int)

    @objc(removeObjectFromNodesAtIndex:)
    @NSManaged public func removeFromNodes(at idx: Int)

    @objc(insertNodes:atIndexes:)
    @NSManaged public func insertIntoNodes(_ values: [CDNode], at indexes: NSIndexSet)

    @objc(removeNodesAtIndexes:)
    @NSManaged public func removeFromNodes(at indexes: NSIndexSet)

    @objc(replaceObjectInNodesAtIndex:withObject:)
    @NSManaged public func replaceNodes(at idx: Int, with value: CDNode)

    @objc(replaceNodesAtIndexes:withNodes:)
    @NSManaged public func replaceNodes(at indexes: NSIndexSet, with values: [CDNode])

    @objc(addNodesObject:)
    @NSManaged public func addToNodes(_ value: CDNode)

    @objc(removeNodesObject:)
    @NSManaged public func removeFromNodes(_ value: CDNode)

    @objc(addNodes:)
    @NSManaged public func addToNodes(_ values: NSOrderedSet)

    @objc(removeNodes:)
    @NSManaged public func removeFromNodes(_ values: NSOrderedSet)

}
