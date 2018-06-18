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

    var readingListByTags: [(tag: String, nodes: [Node])] = [(String, [Node])]()

    var roadmapsInCategories: [Category: Int] = [Category.business:0, Category.education:0, Category.entertainment:0, Category.food:0, Category.health:0, Category.hobby:0, Category.lifestyle:0, Category.news:0, Category.other:0, Category.sport:0, Category.technology:0, Category.travel:0 ]

    var roadmaps: [WritableRoadmap]?

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

        var roadmapsLoaded = DatabaseInterface.shared.loadRoadmaps() ?? [WritableRoadmap]()
        roadmapsLoaded = roadmapsLoaded.sorted { (roadmapOne, roadmapTwo) -> Bool in
            return roadmapOne.category.rawValue < roadmapTwo.category.rawValue
        }
        self.roadmaps = roadmapsLoaded

        loadRoadmapsForCategories()
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

}
