//
//  AddStepsTableViewController.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 04/06/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class AddStepsTableViewController: UITableViewController, UITextFieldDelegate {
    
    //    var numberOfRows = 1 //Initial number of the rows
    var steps: [Step] = [] //Array of steps in current roadmap
    var rowEntrance: [Bool] = [false] //It will be useful to detect if we have to add new rows to the tableView
    var inputCellPath: IndexPath? //It will be useful to retrieve the table view cell for input
    
    //The following four lines of code defines the four color that will create the gradient for the background color
    let firstBackgroundColor = UIColor(red: 1, green: 247/255, blue: 68/255, alpha: 0.8 * 0.59)
    let secondBackgroundColor = UIColor(red: 1, green: 153/255, blue: 68/255, alpha: 0.7 * 0.59)
    let thirdBackgroundColor = UIColor(red: 252/255, green: 96/255, blue: 118/255, alpha: 1 * 0.41)
    let fourthBackgroundColor = UIColor(red: 253/255, green: 107/255, blue: 179/255, alpha: 1 * 0.41)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Invoke xib
        let stepCell = UINib(nibName: "AddStepTableViewCell", bundle: nil)
        self.tableView.register(stepCell, forCellReuseIdentifier: "AddStepTableViewCell")
        
        // Set right bar button save
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveRoadmap(_:)))
        
        // Set title of navigationBar
        self.title = DataSupportRoadmap.shared.getTitleRoadmap()
        
        //Prepare Roadmap
        DataSupportRoadmap.shared.createRoadmap() //Create a roadmap
        if let stepTemp = DataSupportRoadmap.shared.roadmap?.steps { //It retrieves the list of steps from current roadmap
            steps = stepTemp
        }
        
        
        //General settings
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none //delete the separator line between each rows of the tableView
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!) //set the background color
        self.tableView.backgroundColor = UIColor.white //set the background color of the tableView
        
        setTableViewBackgroundGradient(sender: self, firstBackgroundColor, secondBackgroundColor, thirdBackgroundColor, fourthBackgroundColor) //It sets the background color
        
        hideKeyboardWhenTappedAround() //It enables the tap gestures
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2 //There are two section, one for input cell and one for shows the steps added
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return steps.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let stepCell = tableView.dequeueReusableCell(withIdentifier: "AddStepTableViewCell") as! AddStepTableViewCell
        
        //Global settings for cells in table view
        stepCell.titleTextField.delegate = self
        
        if indexPath.section == 0 { //If is the section for the input cell:
            stepCell.titleTextField.frame.size.width = 319
            stepCell.addResourceButton.isHidden = true
            stepCell.titleTextField.tag = -1
            stepCell.titleTextField.placeholder = "What is the step \(steps.count + 1) ?"
            inputCellPath = indexPath
        } else { //If is the section for created steps:
            stepCell.titleTextField.text = steps[indexPath.row].title
            stepCell.titleTextField.tag = indexPath.row
            stepCell.addResourceButton.tag = indexPath.row
            stepCell.addResourceButton.addTarget(self, action: #selector(addResourceToStep(_: )), for: UIControlEvents.touchUpInside) //It enables the action to present the Resource view to the button of each button of the tableView
            //
            UIView.animate(withDuration: 1, delay: 0, animations: {
                if stepCell.titleTextField.frame.size.width == 319 {
                    stepCell.titleTextField.frame.size.width = 246 //It reduces the dimension of the width of the titleTextField with an animation
                }
            }, completion: {_ in stepCell.addResourceButton.isHidden = false}) //At the end of the previous animation, the addResourceButton appears
 
        }
        
        return stepCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func textFieldShouldReturn(_ titleTextField: UITextField) -> Bool { //This function is called when the user taps on the "Done" button of the keyboard
        
        if titleTextField.text!.isEmpty {
            //If the titleTextField is empty, it appears an alert because the user has to insert a title
            let alert = UIAlertController(title: "No Title", message: "Insert a title for the step!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {_ in return}))
            self.present(alert, animated: true, completion: nil)
        } else {
            DataSupportRoadmap.shared.setTitleStep(titleTextField.text!) //It temporaly save title of the step in Data Support Roadmap
            if titleTextField.tag == -1 {
                DataSupportRoadmap.shared.createStep(steps.count - 1) //It create a Step in the syngleton Data Support Roadmap
                titleTextField.text?.removeAll()
            } else {
                DataSupportRoadmap.shared.roadmap?.steps[titleTextField.tag].title = titleTextField.text! //Simple update of step title
            }
            steps = (DataSupportRoadmap.shared.roadmap?.steps!)! //It updates the array of steps
            self.tableView.reloadData() //It loads new datas for the tableView
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
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc func addResourceToStep(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AttachResources", bundle: nil)
        let resourcesViewController = storyboard.instantiateViewController(withIdentifier: "AttachResources") as! AttachResourcesTableViewController
        resourcesViewController.indexOfStep = sender.tag //It assigns the tag number to the index of the viewController to present
        self.navigationController?.pushViewController(resourcesViewController, animated: true)
    }
    
    //The following function defines the tap gesture
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    //The following function function save the roadmap title and dismiss the keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //The following function calls the textFieldShouldReturn function when the user end the editing of the textField when the user tap around in the screen
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !textField.text!.isEmpty { //If text field is not empty calls below function:
            _ = textFieldShouldReturn(textField)
        }
    }
}
