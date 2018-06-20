//
//  ResearchesTableViewController.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 23/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class ResourcesTableViewController: UITableViewController, MyCustomCellDelegator {

    override func viewDidLoad() {
        super.viewDidLoad()

        //General settings
        self.navigationController?.navigationBar.prefersLargeTitles = true //display large title

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!) //set the background color
    }

    override func viewWillAppear(_ animated: Bool) {
        CurrentData.shared.load()
        print("\n\nLista di tag -> value")
        for (tag, value) in CurrentData.shared.readingListByTags {
            print(tag)
            for elem in value {
                print(elem.title)
            }
            print("\n")
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        print(CurrentData.shared.readingListByTags.count)
        return CurrentData.shared.readingListByTags.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let collectionCell = tableView.dequeueReusableCell(withIdentifier: "collectionViewCell", for: indexPath) as! CollectionTableViewCell

        collectionCell.currentTag = CurrentData.shared.readingListByTags[indexPath.section].tag
        collectionCell.delegate = self      //delegate to use self.delegate.callSegueFromCell(identifier: "...")

        collectionCell.backgroundView = UIImageView(image: UIImage(named: "Background celle.png")!) //It sets the background of the table view rows

        return collectionCell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("HeaderTableViewCell", owner: self, options: nil)?.first as! HeaderTableViewCell
        if section == 0 {
            header.headerLabel.text = CurrentData.shared.readingListByTags[section].tag
        } else {
            header.headerLabel.text = "#" + CurrentData.shared.readingListByTags[section].tag
        }

        return header
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225  //global Constant
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 71   //global Constant
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func callSegueFromCell(identifier: String) {
        self.performSegue(withIdentifier: identifier, sender: self)
    }

}
