//
//  AttachResourcesTableViewController.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 20/06/2018.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class AttachResourcesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        let navController = UINavigationController(rootViewController: AddStepsTableViewController)
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AttachResourcesTableViewController.done))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    @objc func done() {
        print("done")
    }
}
