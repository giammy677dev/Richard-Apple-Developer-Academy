//
//  UITableViewController.swift
//  Final Challenge
//
//  Created by Stefano Formicola on 20/06/2018.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewController {
    open override func viewDidLoad() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.dataFetchedFromCloud, object: nil, queue: nil) { notification in
            DispatchQueue.main.sync {
                CurrentData.shared.load()
                self.tableView.reloadData()
            }
        }
        super.viewDidLoad()
    }
}
