//
//  AddStepsTableViewController.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 04/06/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class AddStepsTableViewController: UITableViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Invoke xib
        let stepCell = UINib(nibName: "TitleTableViewCell", bundle: nil)
        self.tableView.register(stepCell, forCellReuseIdentifier: "TitleTableViewCell")

        //General settings
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none //delete the separator line between each rows of the tableView

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!) //set the background color
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let stepCell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as! TitleTableViewCell

//        stepCell.backgroundView = UIImageView(image: UIImage(named: "Background celle.png")!) //It sets the background of the table view rows

        return stepCell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95  //global Constant
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!) //set the color of the header
        return headerView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
