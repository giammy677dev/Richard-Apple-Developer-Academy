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

        // Set right bar button save:
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveRoadmap(_:)))

        // Set title of navigationBar
        self.title = DataSupportRoadmap.shared.getTitleRoadmap()

        //Prepare Roadmap:
        DataSupportRoadmap.shared.createRoadmap()

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

        if stepCell.titleTextField.frame.width == 318 {
            UIView.animate(withDuration: 1, delay: 0, animations: {
                stepCell.titleTextField.frame.size.width = 246 //It reduces the dimension of the width of the titleTextField with an animation
            }, completion: {_ in stepCell.addResourceButton.isHidden = false}) //At the end of the previous animation, the addResourceButton appears
        }
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

    func textFieldShouldReturn(_ titleTextField: UITextField) -> Bool { //This function is called when the user taps on the "Done" button of the keyboard
        self.view.endEditing(true)

        //The following if-else checks if the titleTextField of the step is empty
        if titleTextField.text?.isEmpty ?? true {
            //If the titleTextField is empty, it appears an alert because the user has to insert a title
            let alert = UIAlertController(title: "No Title", message: "Insert a title for the step!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            //The following lines of code add a new row and modify the tableView when the user close the keyboard and there is some text in the textField
            tableView.beginUpdates() //It starts the modification of the tableView
            tableView.insertRows(at: [IndexPath(row: numberOfRows, section: 0)], with: .automatic) //It adds the new row at the end of the tableView
            DataSupportRoadmap.shared.setTitleStep(titleTextField.text!) //It temporaly save title of the step in Data Support Roadmap
            DataSupportRoadmap.shared.createStep(numberOfRows - 1) //It create a Step in the syngleton Data Support Roadmap
            numberOfRows += 1 //It increases the number of rows
            tableView.endUpdates() //It ends the modification of the tableView
            tableView.reloadData() //It loads new datas for the tableView

            titleTextField.frame.size.width = 318 //It reduces of one the width of the titleTextField to enable the animation in the cellForRowAt func
        }
        return true
    }

    //Action on save button:
    @objc func saveRoadmap(_ sender: UIBarButtonItem) {
        //Save roadmap:
        DataSupportRoadmap.shared.saveRoadmap()
        //Update data in CurrentData singleton:
        CurrentData.shared.load()
        //Update elements in the table view of first view controller:
        let destViewController = self.navigationController?.viewControllers.first as! RoadmapsTableViewController
        destViewController.tableView.reloadData()
        //Show an alert with informations about saving:
        let alert = UIAlertController(title: "Saved", message: "Your roadmap has been successfully saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {_ in
            //Go to the first view:
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
