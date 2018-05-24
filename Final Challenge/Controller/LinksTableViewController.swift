//
//  LinksTableViewController.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 24/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class LinksTableViewController: UITableViewController {
    let overlapHeight: Double = 10.0

    override func viewDidLoad() {
        super.viewDidLoad()

        let customCell = UINib(nibName: "CustomLinksTableViewCell", bundle: nil)
        self.tableView.register(customCell, forCellReuseIdentifier: "CustomLinksTableViewCell")

        // General settings
        self.navigationController?.navigationBar.prefersLargeTitles = true

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 10
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomLinksTableViewCell", for: indexPath) as! CustomLinksTableViewCell

        return cell
    }

}
