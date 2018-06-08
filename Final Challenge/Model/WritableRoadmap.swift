//
//  WritableRoadmap.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 21/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation

class WritableRoadmap: Roadmap, Writable {

    //Methods:
    func edit(title: String? = nil, category: Category? = nil) {
        if let newTitle = title {
            self.title = newTitle
        } else { //Default if title is nil
            self.title = ""
        }
        if let newCategory = category {
            self.category = newCategory
        } else { //Default if categori is nil
            self.category = Category.other
        }
    }

    func addStep(_ step: Step) {
        step.parent = self.getRoadmapUUID()
        step.indexInParent = self.steps.count
        self.steps.append(step)
    }

    func removeStep(_ step: Step) {
        if let index = self.steps.index(of: step) {
            self.steps.remove(at: index)
            self.steps.forEach { (step) in
                step.indexInParent = self.steps.index(of: step)
            }
        }
    }

    func move(_ step: Step, after: Step) {
        if self.steps != nil {
            guard let index = steps?.index(of: step) else { //Index of the element to move
                return
            }
            guard let destination = steps?.index(of: after) else { //Index of the element "after"
                return
            }
            guard let target = steps?.index(after: destination) else { //Index where to insert the moved element
                return
            }

            //Move the element:
            self.steps?.insert(step, at: target) //Insert the element at the new position
            self.steps?.remove(at: index) //Remove element from old position
        }
    }

    func swapStep(from: Step, to: Step) {
        guard var container = self.steps else { //Check if the array exist 
            return
        }
        guard let index = steps?.index(of: from) else { //Index of the first element to swap
            return
        }
        guard let destination = steps?.index(of: to) else { //Index of the second element to swap
            return
        }
        //Swap the elements:
        container[index] = to
        container[destination] = from
    }

    func insertStepInHead(_ step: Step) {
        if steps == nil {
            self.addStep(step)
        } else {
            self.steps!.insert(step, at: steps!.startIndex)
        }
    }

    func insertStep(_ step: Step, after: Step) {
        if self.steps == nil {
            self.addStep(step)
        } else {
            guard let index = self.steps?.index(of: after) else {
                return
            }
            guard let target = self.steps?.index(after: index) else {
                return
            }
            self.steps?.insert(step, at: target)
        }
    }
}
