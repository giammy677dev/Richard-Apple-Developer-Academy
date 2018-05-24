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


class CoreDataStack {
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Persistence")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
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




class CoreDataController {
    static let shared = CoreDataController()
    var context: NSManagedObjectContext
    
    //  MARK: Init
    
    init() {
        self.context = CoreDataStack.persistentContainer.viewContext
    }
    
    //  MARK: Save
    
    func saveContext() {
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //  MARK: Add object with or without relationships
    func addRoadmap(_ roadmap: Roadmap) -> Bool {
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
        
        return true
    }
    
    func addStep(_ step: Step, to roadmap: Roadmap) -> Bool {
        
        let entityStep = NSEntityDescription.entity(forEntityName: "CDStep", in: self.context)
        let newStep = CDStep(entity: entityStep!, insertInto: context)
        
        let parentRoadmap = fetchCDRoadmap(uuid: roadmap.uuid)
        
        newStep.setValue(0, forKey: "arrayID")
        newStep.setValue(step.title, forKey: "title")
        newStep.setValue(step.uuid, forKey: "uuid")
        
        newStep.setValue(addUUID(step.uuid), forKey: "usedID")
        
        parentRoadmap!.addToStepsList(newStep)
        
        
        return true
    }
    
    func addNode(_ node: Node) -> CDNode? {
        let newNode = NSEntityDescription.insertNewObject(forEntityName: "CDNode", into: context) as! CDNode
        newNode.setValue(node.creationTimestamp, forKey: "creationTimestamp")
        newNode.setValue(node.extractedText, forKey: "extractedText")
        newNode.setValue(node.isTextProperlyExtracted, forKey: "isTextProperlyExtracted")
        newNode.setValue(node.isRead, forKey: "isRead")
        newNode.setValue(node.isFlagged, forKey: "isFlagged")
        newNode.setValue(node.readingTimeInMinutes, forKey: "readingTimeInMinutes")
        newNode.setValue(node.tags.sorted() as [NSString], forKey: "tags")
        newNode.setValue(node.title, forKey: "title")
        newNode.setValue(node.url.absoluteString , forKey: "url")
        newNode.setValue(node.uuid, forKey: "uuid")
        
        
        newNode.setValue(addUUID(node.uuid), forKey: "usedID")
        
        self.saveContext()
        return newNode
    }
    
    func addNode(_ node: Node, to step: Step) -> Bool {
        
        let entityNode = NSEntityDescription.entity(forEntityName: "CDNode", in: self.context)
        let newNode = CDNode(entity: entityNode!, insertInto: context)
        
        let parentStep = fetchCDStep(uuid: step.uuid)
        
        
        parentStep!.addToNodesList(newNode)
        
        self.saveContext()
        
        return true
    }
    
    func addUUID(_ uuid: UUID) -> CDUsedUUID? {
        
        let newUUID = NSEntityDescription.insertNewObject(forEntityName: "CDUsedUUID", into: context) as! CDUsedUUID
        newUUID.setValue(uuid, forKey: "uuid")
        self.saveContext()
        
        return newUUID
    }
    
    //  MARK: Fetches and checks
    func fetchCDRoadmap(uuid: UUID) -> CDRoadmap? {
        let fetchRequest: NSFetchRequest<CDRoadmap> = CDRoadmap.fetchRequest()
        let predicate = NSPredicate(format: "uuid = %@", uuid as CVarArg)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        var roadmap: CDRoadmap?
        
        do {
            roadmap = try context.fetch(fetchRequest)[0]
            return roadmap!
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func fetchCDStep(uuid: UUID) -> CDStep? {
        let fetchRequest: NSFetchRequest<CDStep> = CDStep.fetchRequest()
        let predicate = NSPredicate(format: "uuid = %@", uuid as CVarArg)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        var step: CDStep?
        
        do {
            step = try context.fetch(fetchRequest)[0]
            return step!
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        
    }
    
    func fetchCDNode(uuid: UUID) -> CDNode? {
        let fetchRequest: NSFetchRequest<CDNode> = CDNode.fetchRequest()
        let predicate = NSPredicate(format: "uuid = %@", uuid as CVarArg)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        var node: CDNode?
        
        do {
            node = try context.fetch(fetchRequest)[0]
            return node!
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        
    }
    
    func fetchRoadmaps() -> [CDRoadmap]?{
        var roadmaps:[CDRoadmap]
        
        do {
            roadmaps = try context.fetch(CDRoadmap.fetchRequest())
            return roadmaps
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func fetchNodes() -> [CDNode]?{
        var nodes:[CDNode]
        
        do {
            nodes = try context.fetch(CDNode.fetchRequest())
            return nodes
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func fetchNodes(read: Bool) -> [CDNode]?{
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
    
    func fetchNodes(flag: Bool) -> [CDNode]?{
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
    
    func fetchUUID(_ uuid: UUID) -> CDUsedUUID?{
        let fetchRequest: NSFetchRequest<CDUsedUUID> = CDUsedUUID.fetchRequest()
        let predicate = NSPredicate(format: "uuid = %@", uuid as CVarArg)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        var id: [CDUsedUUID]?
        
        do {
            id = try context.fetch(fetchRequest)
            if (id?.count != 0){
                return id![0]
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        return nil
    }
    
    func isUUIDInUse(_ id: UUID) -> Bool {
        if fetchUUID(id) != nil{
            return true
        }
        return false
    }
    
    //  MARK: Remove relationships
    
    func removeNode( _ node: Node, from step: Step) -> Bool {
        
        var nodeToRemove: CDNode?
        nodeToRemove = fetchCDNode(uuid: node.uuid)
        
        let step = fetchCDStep(uuid: step.uuid)
        step?.removeFromNodesList(nodeToRemove!)
        
        self.saveContext()
    
        return true
    }
    
    //  MARK: Delete
    
    func deleteRoadmap(_ roadmap: Roadmap) -> Bool {
        var roadmapToRemove: CDRoadmap?
        roadmapToRemove = fetchCDRoadmap(uuid: roadmap.uuid)
        
        context.delete(roadmapToRemove!)
        
        self.saveContext()
        
        return true
    }
    
    func deleteStep(_ step: Step) -> Bool {
        var stepToRemove: CDStep?
        stepToRemove = fetchCDStep(uuid: step.uuid)
        
        context.delete(stepToRemove!)
        
        self.saveContext()
        
        return true
    }
    
    func deleteNode(_ node: Node) -> Bool {
        var nodeToRemove: CDNode?
        nodeToRemove = fetchCDNode(uuid: node.uuid)
        
        context.delete(nodeToRemove!)
        
        self.saveContext()
        
        return true
    }
    
    
    
    //  MARK: Edit
    //  TODO: Update data Roadmap/step/node and change step placement in the roadmap
    
    //  MARK: DANGEROUS
    
    func wipeTheEntireCoreDataContainer(areYouSure y : Bool){
        if (y){
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

