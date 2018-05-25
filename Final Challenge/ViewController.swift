//
//  ViewController.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 14/05/18.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIViewController {
    func CoreDataTest(){
        let a = Roadmap(title: "Come fare il pene", category: .travel, visibility: .isPrivate, privilages: .isOwner, lastRead: Date(), id: UUID())
        
        let controller = CoreDataController.shared
        controller.wipeTheEntireCoreDataContainer(areYouSure: true)
        controller.addRoadmap(a)
        
        let b = Step(title: "Gianni", parent: a, id: UUID())
        controller.addStep(b, to: a)
        let c = Step(title: "Paolo", parent: a, id: UUID())
        controller.addStep(c, to: a)
        
        let d = Node(url: URL(string: "https://www.a.com")!, title: "Come ammazzare i maiali", id: UUID(), parent: b, tags: "#fff", text: "Omae wa mou shindeiru", propExtracted: false)
        controller.addNode(d)
        controller.linkNode(d, to: c)
        
        
        
        debugPrint(controller.fetchRoadmaps(),controller.isUUIDInUse(d.uuid))
        debugPrint(controller.fetchNodes())
        controller.deleteStep(c)
        debugPrint(controller.isUUIDInUse(d.uuid))
        controller.deleteNode(d)
        debugPrint(controller.isUUIDInUse(d.uuid))
    }
}
