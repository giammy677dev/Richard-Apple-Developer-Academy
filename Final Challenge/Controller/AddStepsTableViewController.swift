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

        //Invoke xib
        let stepCell = UINib(nibName: "AddStepTableViewCell", bundle: nil)
        self.tableView.register(stepCell, forCellReuseIdentifier: "AddStepTableViewCell")

        //General settings
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none //delete the separator line between each rows of the tableView
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!) //set the background color
        self.tableView.backgroundColor = UIColor.white //set the background color of the tableView
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let stepCell = tableView.dequeueReusableCell(withIdentifier: "AddStepTableViewCell", for: indexPath) as! AddStepTableViewCell

        stepCell.titleTextField.delegate = self

        return stepCell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
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

        if titleTextField.text?.isEmpty ?? true {
            titleTextField.placeholder = "Insert a title for the roadmap!"
            print("textField is empty")
        } else {
            //The following lines of code add a new row and modify the tableView when the user close the keyboard and there is some text in the textField
            tableView.beginUpdates() //It starts the modification of the tableView
            tableView.insertRows(at: [IndexPath(row: numberOfRows, section: 0)], with: .automatic) //It adds the new row at the end of the tableView
            numberOfRows += 1 //It increases the number of rows
            tableView.endUpdates() //It ends the modification of the tableView
            tableView.reloadData() //It loads new datas for the tableView

            print("textField has some text")
        }
        return true
    }
}
