//
//  Sharable.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 21/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation
//MARK: - Sharable protocol
protocol Sharable {
    //Properties:
    var visibility: RoadmapVisibility {get set}
    var isShared: Bool {get}
    var isPublic: Bool {get}
    var privileges: UserPrivilege {get set}
    
    //Methods:
    func setShared()
    func setPublic()
    func setPrivate()
    func stopSharing()
    func share()
    func publish()
}
