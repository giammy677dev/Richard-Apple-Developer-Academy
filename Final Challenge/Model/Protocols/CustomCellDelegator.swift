//
//  customCellDelegator.swift
//  Final Challenge
//
//  Created by Geremia De Micco on 29/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation
import SafariServices

protocol MyCustomCellDelegator {
    func callSegueFromCell(identifier: String)
    func callSVC(svc: SFSafariViewController)
}
