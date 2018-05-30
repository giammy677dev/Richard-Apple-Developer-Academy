//
//  AddResourceTableViewController.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 27/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class AddResourceTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Invoke xib
        let resourceCell = UINib(nibName: "AddResourceTableViewCell", bundle: nil)
        self.tableView.register(resourceCell, forCellReuseIdentifier: "AddResourceTableViewCell")

        let tagsCell = UINib(nibName: "AddTagsTableViewCell", bundle: nil)
        self.tableView.register(tagsCell, forCellReuseIdentifier: "AddTagsTableViewCell")

        //General settings
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none //delete the separator line between each rows of the tableView

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!) //set the background color
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: UITableViewCell

        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "AddResourceTableViewCell", for: indexPath) as! AddResourceTableViewCell
            return cell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "AddTagsTableViewCell", for: indexPath) as! AddTagsTableViewCell
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 207
        } else {
            return 346
        }
    }

    @IBAction func saveResource(_ sender: UIBarButtonItem) {
        let resourceCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! AddResourceTableViewCell
        let tagsCell: AddTagsTableViewCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! AddTagsTableViewCell

        let node = Node(url: URL(string: resourceCell.URLTextField.text!)!,
            title: resourceCell.titleTextField.text!,
            id: DatabaseInterface.shared.createUniqueUUID(),
            parent: nil,
            tags: tagsCell.tagTextField.text,
            text: "",
            propExtracted: false)

        DatabaseInterface.shared.save(node)
    }

}
