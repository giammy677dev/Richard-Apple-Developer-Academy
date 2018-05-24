//
//  ResearchesTableViewController.swift
//  Final Challenge
//
//  Created by Geremia De Micco on 23/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class ResourcesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //General settings
        self.navigationController?.navigationBar.prefersLargeTitles = true //display large title
       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let collectionCell = tableView.dequeueReusableCell(withIdentifier: "ResourcesCollectionTableViewCell", for: indexPath) as! ResourcesCollectionTableViewCell
        
        
        return collectionCell
    }
    
    //header uguale all'header dell'overview ROADMAOPS
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("HeaderTableViewCell", owner: self, options: nil)?.first as! HeaderTableViewCell
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140  //global Constant
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40   //global Constant
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

}
