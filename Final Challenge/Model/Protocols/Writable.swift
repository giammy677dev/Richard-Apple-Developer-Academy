//
//  Writable.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 21/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation
// MARK: - Writable protocol
protocol Writable {
    func insertStepInHead(_ step: Step)
    func insertStep(_ step: Step, after: Step)
    func appendStep(_ step: Step)
    func removeStep(_ step: Step)
    func move(_ step: Step, after: Step)
    func swapStep(from: Step, to: Step)
}
