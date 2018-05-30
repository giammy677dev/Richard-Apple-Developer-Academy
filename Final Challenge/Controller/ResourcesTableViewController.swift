//
//  ResearchesTableViewController.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 23/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class ResourcesTableViewController: UITableViewController, MyCustomCellDelegator {

    func callSegueFromCell(identifier: String) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //General settings
        self.navigationController?.navigationBar.prefersLargeTitles = true //display large title

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!) //set the background color

//                let customCell = UINib(nibName: "collectionViewCell", bundle: nil)
//                self.tableView.register(customCell, forCellReuseIdentifier: "collectionViewCell")
//
//                let headerCustomCell = UINib(nibName: "headerCell", bundle: nil)
//                self.tableView.register(headerCustomCell, forCellReuseIdentifier: "headerCell")
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let collectionCell = tableView.dequeueReusableCell(withIdentifier: "collectionViewCell", for: indexPath) as! CollectionTableViewCell

        collectionCell.delegate = self

        collectionCell.backgroundView = UIImageView(image: UIImage(named: "Background celle.png")!) //It sets the background of the table view rows

        return collectionCell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("HeaderTableViewCell", owner: self, options: nil)?.first as! HeaderTableViewCell

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

}

//extension RoadmapsTableViewController: MyCustomCellDelegator{
////    func callSegueFromCell(identifier: String) {
////        print("Ciao")
////        self.performSegue(withIdentifier: identifier, sender: self)
////    }
//}
