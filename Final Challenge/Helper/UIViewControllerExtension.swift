//
//  ViewController.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 14/05/18.
//

import UIKit

//Extension of UIViewController to test CoreData init
extension UIViewController {
    
    func CoreDataTest() {
        let a = WritableRoadmap(title: "Come fare il pane", category: .travel, visibility: .isPrivate, privileges: .isOwner, lastRead: Date(), id: UUID())

        let controller = CoreDataController.shared
        controller.wipeTheEntireCoreDataContainer(areYouSure: true)
        _ = controller.addRoadmap(a)

        let b = Step(title: "Gianni", parent: a.getRoadmapUUID(), id: UUID())
        _ = controller.addStep(b, to: a)
        let c = Step(title: "Paolo", parent: a.getRoadmapUUID(), id: UUID())
        _ = controller.addStep(c, to: a)

        let d = Node(url: URL(string: "https://www.a.com")!, title: "Come ammazzare i maiali", id: UUID(), parent: b.getStepUUID(), tags: "#fff", text: "Omae wa mou shindeiru", propExtracted: false)
        _ = controller.addNode(d)
        controller.linkNode(d, to: c)

        controller.deleteStep(c)
    }

    func coreDataInit() {
        let readingListRoadmap = WritableRoadmap(title: "Reading List", category: .other, visibility: .isPrivate, privileges: .isOwner, lastRead: Date(), id: K.readingListRoadmapID)
        let readingListStep = Step(title: "Reading List", parent: K.readingListRoadmapID, id: K.readingListStepID, index: 0)
        CoreDataController.shared.wipeTheEntireCoreDataContainer(areYouSure: true)
        _ = CoreDataController.shared.addRoadmap(readingListRoadmap)
        _ = CoreDataController.shared.addStep(readingListStep, to: readingListRoadmap)
    }
}
