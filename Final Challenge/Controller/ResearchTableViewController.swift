//
//  ResearchTableViewController.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 21/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class ResearchTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //General settings
        self.navigationController?.navigationBar.prefersLargeTitles = true //set large title
        tableView.allowsMultipleSelectionDuringEditing = true //enable multiple selection

        //Search Bar
        let search = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = search

        // The following line displays an Edit button in the navigation bar for the view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = "Prova"

        return cell
    }
}
