//
//  CurrentDataSingleton.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 29/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation

class CurrentData {

    static let shared = CurrentData()

    var currentSingleRoadmap: WritableRoadmap?

    var readingListByTags: [(tag: String, nodes: [Node])] = [(String, [Node])]()

    var roadmapsInCategories: [Category: Int] = [Category.business:0, Category.education:0, Category.entertainment:0, Category.food:0, Category.health:0, Category.hobby:0, Category.lifestyle:0, Category.news:0, Category.other:0, Category.sport:0, Category.technology:0, Category.travel:0 ]

    var roadmaps: [WritableRoadmap]?
    var resources: [Node]?

    var currentCategories: [Category] {
        get {
            var tempCategories: [Category] = []
            var setCategories: Set<Category> = []
            for elem in self.roadmaps! {
                setCategories.insert(elem.category)
            }

            for elem in setCategories {
                tempCategories.append(elem)
            }

            return tempCategories
        }
    }

    private init() {

    }

    func load() { //Load roadmaps and nodes into the arrays

        //LOAD ROADMAPS
        var roadmapsLoaded = DatabaseInterface.shared.loadRoadmaps() ?? [WritableRoadmap]()
        roadmapsLoaded = roadmapsLoaded.sorted { (roadmapOne, roadmapTwo) -> Bool in
            return roadmapOne.category.rawValue < roadmapTwo.category.rawValue
        }
        self.roadmaps = roadmapsLoaded
        loadRoadmapsForCategories()

        //LOAD RESOURCES
        let resourcesLoaded = loadResourcesFromDatabase()
        self.resources = resourcesLoaded
    }

    func loadResourcesFromDatabase() -> [Node] {
        let controller = CoreDataController.shared
        guard let coreDataReadingListRoadmap = controller.fetchCDRoadmap(uuid: K.readingListRoadmapID) else {
            debugPrint("[CDERROR] No reading list found")
            return []
        }
        let readingListRoadmap = controller.getEntireRoadmapFromRecord(coreDataReadingListRoadmap)
//        print(readingListRoadmap.steps)
        let readingListStep = readingListRoadmap.steps[0]
//        print(readingListStep.nodes)
        let readingListNodes = readingListStep.nodes
//        print(readingListNodes![0].title)

        let recentNodes = readingListNodes?.sorted(by: {(node1, node2) in
            return node1.creationTimestamp < node2.creationTimestamp
        })

        print("\nResources loaded:")
        for node in recentNodes! {
            print("title:")
            print(node.title)
        }

        var tags = Set<String>()
        for node in recentNodes! {
            tags = tags.union(node.tags)
        }

        let tagArray = tags.sorted()
        CurrentData.shared.readingListByTags = [(String, [Node])]()
        CurrentData.shared.readingListByTags.append(("Recent", recentNodes!))

        for tag in tagArray {
            var group = [String: [Node]]()
            group[tag] = [Node]()
            for node in recentNodes! {
                if node.tags.contains(tag) {
                    group[tag]?.append(node)
                }
            }
            CurrentData.shared.readingListByTags.append((tag, group[tag]!))
        }
        return recentNodes!
    }

    private func loadRoadmapsForCategories() {
        //Reset the number of roadmaps for categories before count them
        self.resetNumberRoadmaps()
        for elem in roadmaps! {
            roadmapsInCategories[elem.category] = roadmapsInCategories[elem.category]! + 1
        }
    }

    private func resetNumberRoadmaps() { //Set to zero all the values for each key in the Dictionary
        for elem in roadmapsInCategories {
            roadmapsInCategories[elem.key] = 0
        }
    }

    func roadmapsForCategory(category: Category) -> [WritableRoadmap] {
        var returnArray: [WritableRoadmap] = []
        for roadmap in roadmaps! {
            if roadmap.category == category {
                returnArray.append(roadmap)
            }
        }
        return returnArray
    }

    func resourcesForTag(tag: String) -> [Node] {
        var returnArrray: [Node] = []
        for elem in readingListByTags {
            if elem.tag == tag {
                returnArrray = elem.nodes
            }
        }
        return returnArrray
    }

}
