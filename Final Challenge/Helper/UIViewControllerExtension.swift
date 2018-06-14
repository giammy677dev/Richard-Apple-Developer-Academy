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
        let a = WritableRoadmap(title: "Come fare il pene", category: .travel, visibility: .isPrivate, privileges: .isOwner, lastRead: Date(), id: UUID())

        let controller = CoreDataController.shared
        controller.wipeTheEntireCoreDataContainer(areYouSure: true)
        controller.addRoadmap(a)

        let b = Step(title: "Gianni", parent: a.getRoadmapUUID(), id: UUID())
        controller.addStep(b, to: a)
        let c = Step(title: "Paolo", parent: a.getRoadmapUUID(), id: UUID())
        controller.addStep(c, to: a)

        let d = Node(url: URL(string: "https://www.a.com")!, title: "Come ammazzare i maiali", id: UUID(), parent: b.getStepUUID(), tags: "#fff", text: "Omae wa mou shindeiru", propExtracted: false)
        controller.addNode(d)
        controller.linkNode(d, to: c)

        debugPrint(controller.fetchCDRoadmaps() as Any, controller.isUUIDInUse(d.getNodeUUID()))
        debugPrint(controller.fetchCDNodes() as Any)
        controller.deleteStep(c)
        debugPrint(controller.isUUIDInUse(d.getNodeUUID()))
        print(controller.fetchCDNodesWithoutParent())
        //controller.deleteNode(d)
        //debugPrint(controller.isUUIDInUse(d.uuid))
    }

    func coreDataInit() {
        let readingListRoadmap = WritableRoadmap(title: "Reading List", category: .other, visibility: .isPrivate, privileges: .isOwner, lastRead: Date(), id: K.readingListRoadmapID)
        let readingListStep = Step(title: "Reading List", parent: K.readingListRoadmapID, id: K.readingListStepID, index: 0)
        CoreDataController.shared.wipeTheEntireCoreDataContainer(areYouSure: true)
        CoreDataController.shared.addRoadmap(readingListRoadmap)
        CoreDataController.shared.addStep(readingListStep, to: readingListRoadmap)

        print(CoreDataController.shared.fetchCDRoadmaps())
    }
}
