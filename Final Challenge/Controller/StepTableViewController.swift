//
//  StepTableViewController.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 29/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class StepTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Invoke xib
        let stepCell = UINib(nibName: "StepTableViewCell", bundle: nil)
        self.tableView.register(stepCell, forCellReuseIdentifier: "StepTableViewCell")
        
        //General settings
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none //delete the separator line between each rows of the tableView
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StepTableViewCell", for: indexPath) as! StepTableViewCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
}
