//
//  LinksTableViewController.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 24/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class LinksTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Invoke xib
        let customCell = UINib(nibName: "CustomLinksTableViewCell", bundle: nil)
        self.tableView.register(customCell, forCellReuseIdentifier: "CustomLinksTableViewCell")

        //General settings
        //self.navigationController?.navigationBar.prefersLargeTitles = true //display large title
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none //delete the separator line between each rows of the tableView
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 129
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomLinksTableViewCell", for: indexPath) as! CustomLinksTableViewCell

        cell.selectionStyle = .none //It needs to prevent that the cells are highlighted and not only selected

        //Get the last cells in the tableView
        var totalRow = tableView.numberOfRows(inSection: indexPath.section)
        //first get total rows in that section by current indexPath.
        if indexPath.row == totalRow - 1 {
            cell.footerImageView.alpha = 0
        }

        return cell
    }

}
