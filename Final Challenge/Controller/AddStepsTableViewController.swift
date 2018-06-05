//
//  AddStepsTableViewController.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 04/06/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class AddStepsTableViewController: UITableViewController, UITextFieldDelegate {

    var numberOfRows = 1 //Initial number of the rows

    override func viewDidLoad() {
        super.viewDidLoad()
        let backView = UIView(frame: tableView.frame)
        backView.backgroundColor = .blue
        self.tableView.sendSubview(toBack: backView)
        tableView.delegate = self
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
        return numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let stepCell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as! TitleTableViewCell

        stepCell.titleTextField.delegate = self

        return stepCell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
//        return 95  //global Constant
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!) //set the color of the header
        return headerView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func textFieldShouldReturn(_ titleTextField: UITextField) -> Bool {
        self.view.endEditing(true)

        tableView.beginUpdates() //The following 5 lines of code add a new row when the user close the keyboard
        tableView.insertRows(at: [IndexPath(row: numberOfRows, section: 0)], with: .automatic)
        numberOfRows += 1
        tableView.endUpdates()
        tableView.reloadData()

        return true
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        return footerView
    }

}
