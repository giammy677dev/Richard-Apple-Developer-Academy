//
//  ResearchesTableViewController.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 23/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit
import SafariServices

class ResourcesTableViewController: UITableViewController, MyCustomCellDelegator, SFSafariViewControllerDelegate {

    //The following four lines of code defines the four color that will create the gradient for the background color
    let firstBackgroundColor = UIColor(red: 1, green: 247/255, blue: 68/255, alpha: 0.8 * 0.59)
    let secondBackgroundColor = UIColor(red: 1, green: 153/255, blue: 68/255, alpha: 0.7 * 0.59)
    let thirdBackgroundColor = UIColor(red: 252/255, green: 96/255, blue: 118/255, alpha: 1 * 0.41)
    let fourthBackgroundColor = UIColor(red: 253/255, green: 107/255, blue: 179/255, alpha: 1 * 0.41)

    override func viewDidLoad() {
        super.viewDidLoad()

        //General settings
        self.navigationController?.navigationBar.prefersLargeTitles = true //display large title

        setTableViewBackgroundGradient(sender: self, firstBackgroundColor, secondBackgroundColor, thirdBackgroundColor, fourthBackgroundColor) //It sets the background color
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

        collectionCell.backgroundColor = UIColor.clear

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

    //CUSTOM PROTOCOL
    func callSegueFromCell(identifier: String) {
        self.performSegue(withIdentifier: identifier, sender: self)
    }

    func callSVC(svc: SFSafariViewController) {
        self.present(svc, animated: true, completion: nil)
    }

}
