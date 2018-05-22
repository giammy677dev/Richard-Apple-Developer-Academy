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
    }
    
    func appendStep(_ step: Step) {
        if steps == nil {
            steps = [Step]()
        }
        steps?.append(step)
    }
    
    func removeStep(_ step: Step) {
        guard var container = steps
            else { return }
        let index: Int? = container.index(of: step)
        guard let target = index
            else { return }
        container.remove(at: target)
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
            self.steps?.remove(at: index) //Remove element from old position
            self.steps?.insert(step, at: target) //Insert the element at the new position
        }
    }
    
    func swapStep(from: Step, to: Step) {
    }
    
    func insertStepInHead(_ step: Step) {
        if steps == nil {
            self.appendStep(step)
        } else {
            self.steps!.insert(step, at: steps!.startIndex)
        }
    }
    
    func insertStep(_ step: Step, after: Step) {
        if self.steps == nil {
            self.appendStep(step)
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
