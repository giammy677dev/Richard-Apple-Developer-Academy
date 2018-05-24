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
    @NSManaged public var nodesList: NSOrderedSet?

}

// MARK: Generated accessors for nodesList
extension CDStep {

    @objc(insertObject:inNodesListAtIndex:)
    @NSManaged public func insertIntoNodesList(_ value: CDNode, at idx: Int)

    @objc(removeObjectFromNodesListAtIndex:)
    @NSManaged public func removeFromNodesList(at idx: Int)

    @objc(insertNodesList:atIndexes:)
    @NSManaged public func insertIntoNodesList(_ values: [CDNode], at indexes: NSIndexSet)

    @objc(removeNodesListAtIndexes:)
    @NSManaged public func removeFromNodesList(at indexes: NSIndexSet)

    @objc(replaceObjectInNodesListAtIndex:withObject:)
    @NSManaged public func replaceNodesList(at idx: Int, with value: CDNode)

    @objc(replaceNodesListAtIndexes:withNodesList:)
    @NSManaged public func replaceNodesList(at indexes: NSIndexSet, with values: [CDNode])

    @objc(addNodesListObject:)
    @NSManaged public func addToNodesList(_ value: CDNode)

    @objc(removeNodesListObject:)
    @NSManaged public func removeFromNodesList(_ value: CDNode)

    @objc(addNodesList:)
    @NSManaged public func addToNodesList(_ values: NSOrderedSet)

    @objc(removeNodesList:)
    @NSManaged public func removeFromNodesList(_ values: NSOrderedSet)

}


