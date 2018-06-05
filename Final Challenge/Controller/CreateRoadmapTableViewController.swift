//
//  CreateRoadmapTableViewController.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 29/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class CreateRoadmapTableViewController: UITableViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        //General settings
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(goToAddStep))

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!) //set the background color

        //Invoke xib
        let titleCell = UINib(nibName: "TitleTableViewCell", bundle: nil)
        self.tableView.register(titleCell, forCellReuseIdentifier: "TitleTableViewCell")
        
        let notificationCell = UINib(nibName: "NotificationTableViewCell", bundle: nil)
        self.tableView.register(notificationCell, forCellReuseIdentifier: "NotificationTableViewCell")

        let categoryCell = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        self.tableView.register(categoryCell, forCellReuseIdentifier: "CategoryTableViewCell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as! TitleTableViewCell
            cell.titleTextField.delegate = self
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func goToAddStep() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "AddSteps", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddSteps") as! AddStepsTableViewController
        self.present(newViewController, animated: true, completion: nil)
    }
}
