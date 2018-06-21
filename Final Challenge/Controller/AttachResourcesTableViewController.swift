//
//  AttachResourcesTableViewController.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 20/06/2018.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class AttachResourcesTableViewController: UITableViewController {

    //Index of current step in array of step:
    var indexOfStep: Int = 0 //This value is setted from calling view

    //Current step:
    var currentStep: Step?

    var readingListNodes: [Node] {
        return CurrentData.shared.loadResourcesFromDatabase()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //Retrieve current step:
        currentStep = DataSupportRoadmap.shared.roadmap?.steps[indexOfStep]

        //Retrieve title of this step from the roadmap:
        self.title = currentStep?.title

        self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AttachResourcesTableViewController.done)) //Present the button "Done" in the top right corner

        //The following 3 lines of code declare and present the searchBar
        let searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchResultsUpdater = self as? UISearchResultsUpdating
        self.navigationItem.searchController = searchBar

        //Invoke xib
        let cell = UINib(nibName: "CustomLinksTableViewCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "CustomLinksTableViewCell")
    }

    override func viewWillAppear(_ animated: Bool) { //It allows to present the searchBar directly without scrolling when the view is presented
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }

    override func viewDidAppear(_ animated: Bool) { //It allows to hide the searchBar when the view is scrolled
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readingListNodes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomLinksTableViewCell", for: indexPath) as! CustomLinksTableViewCell

        //Set parameters of the cell:
        cell.titleLabel.text = readingListNodes.safeCall(indexPath.item)?.title
        
        //Set check button of the cell:
        cell.checkButton.tag = indexPath.item
        cell.checkButton.addTarget(self, action: #selector(attachNode(_:)), for: UIControlEvents.touchUpInside)
        
        //If the current step already contains the node:
        if currentStep?.nodes?.contains(readingListNodes[indexPath.item]) ?? false {
            cell.checkButton.isSelected = true //Put the button in selected state
            cell.checkButton.setImage(UIImage(named: "CheckOn"), for: .selected) //Set the image for selected state
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    //Function to attach the node to the current step
    @objc func attachNode(_ sender: UIButton) {
        if sender.isSelected == false { //If the button has not been selected yet
            //Attach Node to current Step:
            print("Number of nodes: \(readingListNodes.count), button number: \(sender.tag)")
            currentStep?.addNode(readingListNodes[sender.tag])
        } else {
            //Remouve Node:
            currentStep?.removeNode(readingListNodes[sender.tag])
        }
        
    }

    @objc func done() {
        //Return to previous view:
        self.navigationController?.popViewController(animated: true)
    }
}
