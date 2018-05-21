//
//  Writable.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 21/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation
//MARK: - Writable protocol
protocol Writable {
    func appendStep()
    func removeStep(_ step: Step)
    func move(after: Step)
    func swapStep(from: Step, to: Step)
}
