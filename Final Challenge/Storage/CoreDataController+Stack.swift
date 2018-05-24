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
        let container = NSPersistentContainer(name: "com.bel-e-buono.final-challenge")
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
    func addRoadmap(roadmap: Roadmap) -> Bool {
        let newRoadmap = NSEntityDescription.insertNewObject(forEntityName: "CDRoadmap", into: context) as! CDRoadmap
        
        newRoadmap.setValue(roadmap.title, forKey: "title")
        newRoadmap.setValue(roadmap.isPublic, forKey: "isPublic")
        self.saveContext()
        
        return true
    }
    
    //  MARK: Fetch
    
    
    //  MARK: Delete
    
    
    //  MARK: Edit
    
    
}
