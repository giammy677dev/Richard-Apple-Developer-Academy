//
//  CoreDataController.swift
//  Final Challenge
//
//  Created by Andrea Belcore on 24/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation
import CoreData
import UIKit

///Class used to manage the persistent container.
class CoreDataStack {
    ///Persistent conteiner used by CoreData.
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         Note that it must have the same name as the *.xcdatamodeld file!!
         */
        let container = NSPersistentContainer(name: "Persistence")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    ///Saves the current context of the container.
    func saveContext () {
        let context = CoreDataStack.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

///Controller of Core Data. Best prectice is to use the .shared instance to interact with data.
class CoreDataController {

    ///Shared singleton, used to read and write data.
    static let shared = CoreDataController()

    var context: NSManagedObjectContext

    // MARK: Init

    ///Sets up the context for R/W interaction.
    private init() {
        self.context = CoreDataStack.persistentContainer.viewContext
    }

    // MARK: Save

    ///Saves current context.
    func saveContext() {
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    // MARK: Add object with or without relationships

    ///Adds Roadmap class to the record, WITHOUT adding Steps and Nodes to it. Returns the CoreData object for Roadmaps.
    func addRoadmap(_ roadmap: Roadmap) -> CDRoadmap? {
        let newRoadmap = NSEntityDescription.insertNewObject(forEntityName: "CDRoadmap", into: context) as! CDRoadmap

        newRoadmap.setValue(roadmap.category.rawValue, forKey: "category")
        newRoadmap.setValue(roadmap.isPublic, forKey: "isPublic")
        newRoadmap.setValue(roadmap.isShared, forKey: "isShared")

        newRoadmap.setValue(roadmap.lastReadTimestamp as NSDate, forKey: "lastReadTimestamp")
        newRoadmap.setValue(roadmap.privileges.rawValue, forKey: "privileges")
        newRoadmap.setValue(roadmap.title, forKey: "title")
        newRoadmap.setValue(roadmap.visibility.rawValue, forKey: "visibility")
        newRoadmap.setValue(roadmap.uuid, forKey: "uuid")

        newRoadmap.setValue(addUUID(roadmap.uuid), forKey: "usedID")

        self.saveContext()

        return newRoadmap
    }

    ///Adds Step class to the record and links it to the roadmap record, WITHOUT adding Nodes to it. Returns the CoreData object for Steps.
    func addStep(_ step: Step, to roadmap: Roadmap) -> CDStep? {

        let entityStep = NSEntityDescription.entity(forEntityName: "CDStep", in: self.context)
        let newStep = CDStep(entity: entityStep!, insertInto: context)

        let parentRoadmap = fetchCDRoadmap(uuid: roadmap.uuid)

        newStep.setValue(0, forKey: "arrayID")
        newStep.setValue(step.title, forKey: "title")
        newStep.setValue(step.uuid, forKey: "uuid")

        newStep.setValue(addUUID(step.uuid), forKey: "usedID")

        parentRoadmap!.addToStepsList(newStep)

        self.saveContext()

        return newStep
    }

    func addStep(_ step: Step, to roadmap: UUID) -> CDStep? {

        let entityStep = NSEntityDescription.entity(forEntityName: "CDStep", in: self.context)
        let newStep = CDStep(entity: entityStep!, insertInto: context)

        let parentRoadmap = fetchCDRoadmap(uuid: roadmap)

        newStep.setValue(0, forKey: "arrayID")
        newStep.setValue(step.title, forKey: "title")
        newStep.setValue(step.uuid, forKey: "uuid")

        newStep.setValue(addUUID(step.uuid), forKey: "usedID")

        parentRoadmap!.addToStepsList(newStep)

        self.saveContext()

        return newStep
    }

    ///Adds Node class to the record. Returns the CoreData object for Nodes.
    func addNode(_ node: Node) -> CDNode? {
        let newNode = NSEntityDescription.insertNewObject(forEntityName: "CDNode", into: context) as! CDNode
        newNode.setValue(node.creationTimestamp, forKey: "creationTimestamp")
        newNode.setValue(node.extractedText, forKey: "extractedText")
        newNode.setValue(node.isTextProperlyExtracted, forKey: "isTextProperlyExtracted")
        newNode.setValue(node.isRead, forKey: "isRead")
        newNode.setValue(node.isFlagged, forKey: "isFlagged")
        newNode.setValue(node.tags, forKey: "tags")
        newNode.setValue(node.title, forKey: "title")
        newNode.setValue(node.url.absoluteString, forKey: "url")
        newNode.setValue(node.uuid, forKey: "uuid")
        newNode.setValue(addUUID(node.uuid), forKey: "usedID")

        self.saveContext()
        return newNode
    }

    ///Links an existing node to a step.
    func linkNode(_ node: Node, to step: Step) {

        let entityNode = NSEntityDescription.entity(forEntityName: "CDNode", in: self.context)
        let newNode = CDNode(entity: entityNode!, insertInto: context)

        let parentStep = fetchCDStep(uuid: step.uuid)

        parentStep!.addToNodesList(newNode)

        self.saveContext()

    }

    ///Adds UUID to the UUIDs in the record, then used to check if an UUID exists or not.
    func addUUID(_ uuid: UUID) -> CDUsedUUID? {

        let newUUID = NSEntityDescription.insertNewObject(forEntityName: "CDUsedUUID", into: context) as! CDUsedUUID
        newUUID.setValue(uuid, forKey: "uuid")
        self.saveContext()

        return newUUID
    }

    // MARK: Fetches and checks

    ///Fetches the CoreData Roadmap corresponding to a given UUID.
    func fetchCDRoadmap(uuid: UUID) -> CDRoadmap? {
        let fetchRequest: NSFetchRequest<CDRoadmap> = CDRoadmap.fetchRequest()
        let predicate = NSPredicate(format: "uuid = %@", uuid as CVarArg)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        var roadmap: CDRoadmap?

        do {
            roadmap = try context.fetch(fetchRequest).safeCall(0)
            return roadmap
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    ///Fetches the CoreData Step corresponding to a given UUID.
    func fetchCDStep(uuid: UUID) -> CDStep? {
        let fetchRequest: NSFetchRequest<CDStep> = CDStep.fetchRequest()
        let predicate = NSPredicate(format: "uuid = %@", uuid as CVarArg)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        var step: CDStep?

        do {
            step = try context.fetch(fetchRequest).safeCall(0)
            return step
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }

    }
    ///Fetches the CoreData Node corresponding to a given UUID.
    func fetchCDNode(uuid: UUID) -> CDNode? {
        let fetchRequest: NSFetchRequest<CDNode> = CDNode.fetchRequest()
        let predicate = NSPredicate(format: "uuid = %@", uuid as CVarArg)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        var node: CDNode?

        do {
            node = try context.fetch(fetchRequest).safeCall(0)
            return node
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }

    }

    ///Fetches every CoreData Roadmap.
    func fetchCDRoadmaps() -> [CDRoadmap]? {
        var roadmaps: [CDRoadmap]

        do {
            roadmaps = try context.fetch(CDRoadmap.fetchRequest())
            return roadmaps
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }

    ///Fetches every CoreData Node.
    func fetchCDNodes() -> [CDNode]? {
        var nodes: [CDNode]

        do {
            nodes = try context.fetch(CDNode.fetchRequest())
            return nodes
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }

    ///Fetches every CoreData Node with a specified isRead flag.
    func fetchCDNodes(read: Bool) -> [CDNode]? {
        let fetchRequest: NSFetchRequest<CDNode> = CDNode.fetchRequest()
        let predicate = NSPredicate(format: "isRead = %@", read)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        var nodes: [CDNode]?

        do {
            nodes = try context.fetch(fetchRequest)
            return nodes
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }

    func fetchCDNodesWithoutParent() -> [CDNode]? {
        let fetchRequest: NSFetchRequest<CDNode> = CDNode.fetchRequest()
        let predicate = NSPredicate(format: "parentsStep = nil")
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        var nodes: [CDNode]?

        do {
            nodes = try context.fetch(fetchRequest)
            return nodes
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }

    ///Fetches every CoreData Node with a specified isFlagged flag.
    func fetchCDNodes(flag: Bool) -> [CDNode]? {
        let fetchRequest: NSFetchRequest<CDNode> = CDNode.fetchRequest()
        let predicate = NSPredicate(format: "isFlagged = %@", flag)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        var nodes: [CDNode]?

        do {
            nodes = try context.fetch(fetchRequest)
            return nodes
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }

    ///Fetches the CoreData UUID record corresponding to a specific UUID.
    func fetchCDUUID(_ uuid: UUID) -> CDUsedUUID? {
        let fetchRequest: NSFetchRequest<CDUsedUUID> = CDUsedUUID.fetchRequest()
        let predicate = NSPredicate(format: "uuid = %@", uuid as CVarArg)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        var id: CDUsedUUID?

        do {
            id = try context.fetch(fetchRequest).safeCall(0)
                return id
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }

    ///Tells if a generated UUID is already in use.
    func isUUIDInUse(_ id: UUID) -> Bool {
        if fetchCDUUID(id) != nil {
            return true
        }
        return false
    }

    // MARK: Remove relationships

    ///Removes the relationship between a Node and a Step.
    func unlinkNode( _ node: Node, from step: Step) {

        var nodeToRemove: CDNode?
        nodeToRemove = fetchCDNode(uuid: node.uuid)

        let step = fetchCDStep(uuid: step.uuid)
        step?.removeFromNodesList(nodeToRemove!)

        self.saveContext()
    }

    // MARK: Delete

    ///Deletes the Roadmap in CoreData, along with its Steps but preserving the nodes.
    func deleteRoadmap(_ roadmap: Roadmap) {
        guard isUUIDInUse(roadmap.uuid) else {
            return
        }
        var roadmapToRemove: CDRoadmap?
        roadmapToRemove = fetchCDRoadmap(uuid: roadmap.uuid)

        context.delete(roadmapToRemove!)

        self.saveContext()
    }

    func deleteRoadmap(_ roadmapID: UUID) {
        guard isUUIDInUse(roadmapID) else {
            return
        }
        var roadmapToRemove: CDRoadmap?
        roadmapToRemove = fetchCDRoadmap(uuid: roadmapID)

        context.delete(roadmapToRemove!)

        self.saveContext()
    }

    ///Deletes the Step in CoreData, preserving the rest.
    func deleteStep(_ step: Step) {
        guard isUUIDInUse(step.uuid) else {
            return
        }
        var stepToRemove: CDStep?
        stepToRemove = fetchCDStep(uuid: step.uuid)

        context.delete(stepToRemove!)

        self.saveContext()

    }

    func deleteStep(_ stepID: UUID) {
        guard isUUIDInUse(stepID) else {
            return
        }
        var stepToRemove: CDStep?
        stepToRemove = fetchCDStep(uuid: stepID)

        context.delete(stepToRemove!)

        self.saveContext()

    }

    ///Deletes the Node in CoreData.
    func deleteNode(_ node: Node) {
        guard isUUIDInUse(node.uuid) else {
            return
        }
        var nodeToRemove: CDNode?
        nodeToRemove = fetchCDNode(uuid: node.uuid)

        context.delete(nodeToRemove!)

        self.saveContext()

    }

    func deleteNode(_ nodeID: UUID) {
        guard isUUIDInUse(nodeID) else {
            return
        }
        var nodeToRemove: CDNode?
        nodeToRemove = fetchCDNode(uuid: nodeID)

        context.delete(nodeToRemove!)
        self.saveContext()

    }

    // MARK: Update

    ///Updates/adds Node information in CoreData. Not recursive.
    func updateNode(_ node: Node) -> CDNode? {
        if let nodeToUpdate = fetchCDNode(uuid: node.uuid) {
            nodeToUpdate.setValue(node.creationTimestamp, forKey: "creationTimestamp")
            nodeToUpdate.setValue(node.extractedText, forKey: "extractedText")
            nodeToUpdate.setValue(node.isTextProperlyExtracted, forKey: "isTextProperlyExtracted")
            nodeToUpdate.setValue(node.isRead, forKey: "isRead")
            nodeToUpdate.setValue(node.isFlagged, forKey: "isFlagged")
            nodeToUpdate.setValue(node.tags, forKey: "tags")
            nodeToUpdate.setValue(node.title, forKey: "title")
            nodeToUpdate.setValue(node.url.absoluteString, forKey: "url")

            self.saveContext()

            return nodeToUpdate
        } else {

            return addNode(node)
        }

    }
    ///Updates/adds Step information in CoreData. Not recursive.
    func updateStep(_ step: Step, of roadmap: Roadmap) -> CDStep? {

        if let stepToUpdate = fetchCDStep(uuid: step.uuid) {
            stepToUpdate.setValue(0, forKey: "arrayID")
            stepToUpdate.setValue(step.title, forKey: "title")

            self.saveContext()

            return stepToUpdate
        } else {
            return addStep(step, to: roadmap)
        }

    }

    func updateStep(_ step: Step, of roadmap: UUID) -> CDStep? {

        if let stepToUpdate = fetchCDStep(uuid: step.uuid) {
            stepToUpdate.setValue(0, forKey: "arrayID")
            stepToUpdate.setValue(step.title, forKey: "title")

            self.saveContext()

            return stepToUpdate
        } else {
            return addStep(step, to: roadmap)
        }

    }
    ///Updates/adds Roadmap information in CoreData. Not recursive.
    func updateRoadmap(_ roadmap: Roadmap) -> CDRoadmap? {
        if let roadmapToUpdate = fetchCDRoadmap(uuid: roadmap.uuid) {
            roadmapToUpdate.setValue(roadmap.category.rawValue, forKey: "category")
            roadmapToUpdate.setValue(roadmap.isPublic, forKey: "isPublic")
            roadmapToUpdate.setValue(roadmap.isShared, forKey: "isShared")

            roadmapToUpdate.setValue(roadmap.lastReadTimestamp as NSDate, forKey: "lastReadTimestamp")
            roadmapToUpdate.setValue(roadmap.privileges.rawValue, forKey: "privileges")
            roadmapToUpdate.setValue(roadmap.title, forKey: "title")
            roadmapToUpdate.setValue(roadmap.visibility.rawValue, forKey: "visibility")

            self.saveContext()
            return roadmapToUpdate
        } else {
            return addRoadmap(roadmap)
        }

    }
    // MARK: Change step/nodes placement
    func moveNode(_ node: Node, in step: Step, at index: Int) {
        let cdnode = fetchCDNode(uuid: node.uuid)
        let cdstep = fetchCDStep(uuid: step.uuid)

        cdstep?.removeFromNodesList(cdnode!)
        cdstep?.insertIntoNodesList(cdnode!, at: index)

        self.saveContext()
    }

    func moveStep(_ step: Step, in roadmap: Roadmap, at index: Int) {
        let cdstep = fetchCDStep(uuid: step.uuid)
        let cdroadmap = fetchCDRoadmap(uuid: roadmap.uuid)

        cdroadmap?.removeFromStepsList(cdstep!)
        cdroadmap?.insertIntoStepsList(cdstep!, at: index)

        self.saveContext()
    }

    // MARK: Recursive update/save

    ///Saves a Roadmap recursively. Nodes must already exist in memory.
    func saveRecursively(_ roadmap: Roadmap) {
        let savedRoadmap = updateRoadmap(roadmap)//Add or update the roadmap that is being saved
        if let savedSteps = savedRoadmap?.stepsList?.array as! [CDStep]? {
            for savedStep in savedSteps {
                context.delete(savedStep)
            }
        }
        if let steps = roadmap.steps {//Steps! Check which ones must be updated/added or deleted
            for step in steps {
                updateStep(step, of: roadmap)
                if let nodes = step.nodes {
                    for node in nodes {
                        linkNode(node, to: step)
                    }
                }
            }
        }
        self.saveContext()
    }

    ///Saves a Roadmap array recursively. Nodes must already exist in memory.
    func saveRecursively(_ roadmaps: [Roadmap]) {
        for roadmap in roadmaps {
            deleteRoadmap(roadmap)
            saveRecursively(roadmap)
        }
        self.saveContext()
    }

    // MARK: Convert CD Classes to normal classes

    ///Converts a CoreData Roadmap record in its Roadmap counterpart. NOT Recursive.
    func roadmapFromRecord(_ cdroadmap: CDRoadmap) -> Roadmap {
        let roadmap = Roadmap(title: cdroadmap.title!,
                              category: Category(rawValue: cdroadmap.category)!,
                              visibility: RoadmapVisibility(rawValue: cdroadmap.visibility)!,
                              privileges: UserPrivilege(rawValue: cdroadmap.privileges)!,
                              lastRead: cdroadmap.lastReadTimestamp! as Date,
                              id: cdroadmap.uuid!)

        return roadmap
    }

    ///Converts a CoreData Step record in its Step counterpart. NOT Recursive.
    func stepFromRecord(_ cdstep: CDStep) -> Step {
        let step = Step(title: cdstep.title!,
                        parent: (cdstep.parentRoadmap?.uuid)!,
                        id: cdstep.uuid!)
        return step
    }

    ///Converts a CoreData Node record in its Node counterpart when it is saved in a Step, so that it gets the parent id.
    func nodeFromRecord(_ cdnode: CDNode, parent cdstep: CDStep) -> Node {
        let node = Node(url: URL(string: cdnode.url!)!,
                        title: cdnode.title!,
                        id: cdnode.uuid!,
                        parent: cdstep.uuid!,
                        tags: cdnode.tags,
                        text: cdnode.extractedText!,
                        propExtracted: cdnode.isTextProperlyExtracted,
                        creationTime: cdnode.creationTimestamp! as Date,
                        propRead: cdnode.isRead,
                        propFlagged: cdnode.isFlagged,
                        index: cdnode.parentsStep?.nodesList?.index(of: cdnode))

        return node
    }

    ///Converts a CoreData Node record in its Node counterpart.
    func nodeFromRecord(_ cdnode: CDNode) -> Node {
        let node = Node(url: URL(string: cdnode.url!)!,
                        title: cdnode.title!,
                        id: cdnode.uuid!,
                        parent: cdnode.parentsStep?.uuid ?? K.readingListID,
                        tags: cdnode.tags,
                        text: cdnode.extractedText!,
                        propExtracted: cdnode.isTextProperlyExtracted,
                        creationTime: cdnode.creationTimestamp! as Date,
                        propRead: cdnode.isRead,
                        propFlagged: cdnode.isFlagged,
                        index: cdnode.parentsStep?.nodesList?.index(of: cdnode))

        return node
    }

    ///Converts a CoreData Step record in its Step counterpart. Recursive.
    func fullStepFromRecord(_ cdstep: CDStep) -> Step {
        let step = stepFromRecord(cdstep)
        if let cdnodes = cdstep.nodesList?.array {
            if (!cdnodes.isEmpty) {
                for cdnode in cdnodes {
                    let node = nodeFromRecord(cdnode as! CDNode)
                    step.addNode(node)
                }
            }
        }
        return step
    }

    ///Converts a CoreData Roadmap record in its Roadmap counterpart. Recursive.
    func getEntireRoadmapFromRecord(_ cdroadmap: CDRoadmap) -> Roadmap {
        let roadmap = roadmapFromRecord(cdroadmap)

        if let cdsteps = cdroadmap.stepsList {
            if (!cdsteps.array.isEmpty) {
                for cdstep in cdsteps.array {
                    let step = fullStepFromRecord(cdstep as! CDStep)
                    roadmap.addStep(step)
                }
            }
        }

        return roadmap
    }

    ///Converts all CoreData Roadmap records in their Roadmap counterpart, giving out an array. Recursive.
    func getFullRoadmapRecords() -> [Roadmap]? {

        if let cdroadmaps = fetchCDRoadmaps() {
            if (!cdroadmaps.isEmpty) {
                var roadmaps = [Roadmap]()
                for cdroadmap in cdroadmaps {
                    roadmaps.append(getEntireRoadmapFromRecord(cdroadmap))
                }
            }
        }
        return nil

    }

    ///Converts all CoreData Node records in their Node counterpart, giving out an array.
    func getEveryNodeRecord() -> [Node]? {
        if let cdnodes = fetchCDNodes() {
            if (!cdnodes.isEmpty) {
                var nodes = [Node]()
                for cdnode in cdnodes {
                    nodes.append(nodeFromRecord(cdnode))
                }
                return nodes
            }
        }
        return nil
    }

    // MARK: DANGEROUS

    ///Wipes everything in the memory. Does not restructure it, so if the container crashes after data modeling the app needs to be reinstalled.
    func wipeTheEntireCoreDataContainer(areYouSure y: Bool) {
        if (y) {
            var deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CDNode")
            var deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print ("There was an error")
            }
            deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CDRoadmap")

            deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print ("There was an error")
            }
             deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CDStep")
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print ("There was an error")
            }
             deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CDUsedUUID")
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print ("There was an error")
            }

            print("[CoreData]: The entire container has been wiped.")
        }

    }

}
