//
//  AddResourceTableViewController.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 27/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class AddResourceTableViewController: UITableViewController {

    //The following four lines of code defines the four color that will create the gradient for the background color
    let firstBackgroundColor = UIColor(red: 1, green: 247/255, blue: 68/255, alpha: 0.8 * 0.59)
    let secondBackgroundColor = UIColor(red: 1, green: 153/255, blue: 68/255, alpha: 0.7 * 0.59)
    let thirdBackgroundColor = UIColor(red: 252/255, green: 96/255, blue: 118/255, alpha: 1 * 0.41)
    let fourthBackgroundColor = UIColor(red: 253/255, green: 107/255, blue: 179/255, alpha: 1 * 0.41)

    override func viewDidLoad() {
        super.viewDidLoad()

        //Invoke xib
        let resourceCell = UINib(nibName: "AddResourceTableViewCell", bundle: nil)
        self.tableView.register(resourceCell, forCellReuseIdentifier: "AddResourceTableViewCell")

        let tagsCell = UINib(nibName: "AddTagsTableViewCell", bundle: nil)
        self.tableView.register(tagsCell, forCellReuseIdentifier: "AddTagsTableViewCell")

        //General settings
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none //delete the separator line between each rows of the tableView

        setTableViewBackgroundGradient(sender: self, firstBackgroundColor, secondBackgroundColor, thirdBackgroundColor, fourthBackgroundColor) //It sets the background color

        hideKeyboardWhenTappedAround()
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

    @IBAction func saveResource(_ sender: UIBarButtonItem) {
        let resourceCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! AddResourceTableViewCell
        let tagsCell: AddTagsTableViewCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! AddTagsTableViewCell

        guard let urlText = resourceCell.URLTextField.text, let title = resourceCell.titleTextField.text, let url = URL(string: urlText) else {
            let alert = UIAlertController(title: "Error", message: "Please fill out all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil ))
            self.present(alert, animated: true, completion: nil)
            return
        }

        let node = Node(url: url,
            title: title,
            id: DatabaseInterface.shared.createUniqueUUID(),
            parent: K.readingListStepID,
            tags: tagsCell.tagTextField.text,
            text: "",
            propExtracted: false)

        DatabaseInterface.shared.save(node)

        let alert = UIAlertController(title: "Saved", message: "Your rescource has been successfully saved", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

}
