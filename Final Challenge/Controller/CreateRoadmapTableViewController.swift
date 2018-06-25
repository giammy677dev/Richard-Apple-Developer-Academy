//
//  CreateRoadmapTableViewController.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 29/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class CreateRoadmapTableViewController: UITableViewController, UITextFieldDelegate {
    var textFieldDelegate: UITextField? //We will use it to handle the keyboard

    //The following four lines of code defines the four color that will create the gradient for the background color
    let firstBackgroundColor = UIColor(red: 1, green: 247/255, blue: 68/255, alpha: 0.8 * 0.59)
    let secondBackgroundColor = UIColor(red: 1, green: 153/255, blue: 68/255, alpha: 0.7 * 0.59)
    let thirdBackgroundColor = UIColor(red: 252/255, green: 96/255, blue: 118/255, alpha: 1 * 0.41)
    let fourthBackgroundColor = UIColor(red: 253/255, green: 107/255, blue: 179/255, alpha: 1 * 0.41)

    override func viewDidLoad() {
        super.viewDidLoad()

        //General settings
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Steps", style: .plain, target: self, action: #selector(goToAddStep))

        //Invoke xib
        let titleCell = UINib(nibName: "TitleTableViewCell", bundle: nil)
        self.tableView.register(titleCell, forCellReuseIdentifier: "TitleTableViewCell")

        let notificationCell = UINib(nibName: "NotificationTableViewCell", bundle: nil)
        self.tableView.register(notificationCell, forCellReuseIdentifier: "NotificationTableViewCell")

        let categoryCell = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        self.tableView.register(categoryCell, forCellReuseIdentifier: "CategoryTableViewCell")

        setTableViewBackgroundGradient(sender: self, firstBackgroundColor, secondBackgroundColor, thirdBackgroundColor, fourthBackgroundColor) //It sets the background color

        hideKeyboardWhenTappedAround() //It enables the tap gesture in this view
        tableView.keyboardDismissMode = .onDrag //It enables the keyboard dismissing on scrolling the tableView
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as! TitleTableViewCell
            cell.titleTextField.delegate = self
            self.textFieldDelegate = cell.titleTextField
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < 2 {
            return 94
        } else {
            return 300
        }
    }

    //When user tap the return button on the keyboard, the keyboard is closed and the roadmap title is saved
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    //When user scroll the textField, the keyboard is closed and the roadmap title is saved
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.endEditing(true)
    }

    //The following function defines the tap gesture
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    //This function save the roadmap title and dismiss the keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    //The following function, save the roadmap title
    private func saveRoadmapTitle() {
        if textFieldDelegate?.text?.isEmpty == false { //If the roadmap title is NOT empty, the title is saved
            let title = textFieldDelegate?.text
            DataSupportRoadmap.shared.setTitleRoadmap(title!)
        }
    }

    //The following function checks if the roadmap title is empty: in that case it throws an alert, else goes to the AddStepsTableViewController()
    @objc func goToAddStep() {
        if !(self.textFieldDelegate?.text?.isEmpty)! { //It enables the saving of the roadmap title also when the "Next" button is tapped
            DataSupportRoadmap.shared.setTitleStep((self.textFieldDelegate?.text)!)
            saveRoadmapTitle()
        } else {
            let alert = UIAlertController(title: "No Title", message: "Please type a title.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        let newViewController = AddStepsTableViewController()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }

}
