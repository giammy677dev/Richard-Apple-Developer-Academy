//
//  AttachResourcesTableViewController.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 20/06/2018.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class AttachResourcesTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    

    //Index of current step in array of step:
    var indexOfStep: Int = 0 //This value is setted from calling view

    //The following four lines of code defines the four color that will create the gradient for the background color
    let firstBackgroundColor = UIColor(red: 1, green: 247/255, blue: 68/255, alpha: 0.8 * 0.59)
    let secondBackgroundColor = UIColor(red: 1, green: 153/255, blue: 68/255, alpha: 0.7 * 0.59)
    let thirdBackgroundColor = UIColor(red: 252/255, green: 96/255, blue: 118/255, alpha: 1 * 0.41)
    let fourthBackgroundColor = UIColor(red: 253/255, green: 107/255, blue: 179/255, alpha: 1 * 0.41)
    
    //SearchBar
    var searchBarController: UISearchController?
    
    //Variables for search
    var shouldShowSearchResults: Bool = false

    //Current step:
    var currentStep: Step?

    var readingListNodes: [Node] {
        return CurrentData.shared.loadResourcesFromDatabase()
    }
    
    var filteredReadingList: [Node] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //Retrieve current step:
        currentStep = DataSupportRoadmap.shared.roadmap?.steps[indexOfStep]

        //Retrieve title of this step from the roadmap:
        self.title = currentStep?.title
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AttachResourcesTableViewController.done)) //Present the button "Done" in the top right corner
        
        //Configure searchBar and searchBarController:
        self.configureSearchController()

        //Invoke xib
        let cell = UINib(nibName: "CustomLinksTableViewCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "CustomLinksTableViewCell")

        setTableViewBackgroundGradient(sender: self, firstBackgroundColor, secondBackgroundColor, thirdBackgroundColor, fourthBackgroundColor) //It sets the background color
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
        if self.shouldShowSearchResults {
            return filteredReadingList.count
        } else {
            return readingListNodes.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomLinksTableViewCell", for: indexPath) as! CustomLinksTableViewCell
        
        var arrayData: [Node]
        
        if shouldShowSearchResults {
            arrayData = filteredReadingList
        } else {
            arrayData = readingListNodes
        }

        //Set parameters of the cell:
        cell.titleLabel.text = arrayData.safeCall(indexPath.item)?.title
        
        //Set initial status of check button, in case of reuse of cell:
        cell.checkButton.isSelected = false

        //Set check button of the cell:
        cell.checkButton.tag = indexPath.item
        cell.checkButton.addTarget(self, action: #selector(attachNode(_:)), for: UIControlEvents.touchUpInside)

        //If the current step already contains the node:
        if currentStep?.nodes?.contains(arrayData[indexPath.item]) ?? false {
            cell.checkButton.isSelected = true //Put the button in selected state
            cell.checkButton.setImage(UIImage(named: "CheckOn"), for: .selected) //Set the image for selected state
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135.5
    }

    //Function to attach the node to the current step
    @objc func attachNode(_ sender: UIButton) {
        
        var arrayData: [Node]
        
        if shouldShowSearchResults {
            arrayData = filteredReadingList
        } else {
            arrayData = readingListNodes
        }
        
        if sender.isSelected == false { //If the button has not been selected yet
            //Attach Node to current Step:
            currentStep?.addNode(arrayData[sender.tag])
        } else {
            //Remouve Node:
            currentStep?.removeNode(arrayData[sender.tag])
        }

    }

    @objc func done() {
        //Return to previous view:
        self.navigationController?.popViewController(animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10   //global Constant
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    // MARK: - Functions for searchBar
    
    private func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchBarController = UISearchController(searchResultsController: nil)
        let searchBar = searchBarController!.searchBar
        
        //Set searcBarController:
        searchBarController!.searchResultsUpdater = self
        searchBarController!.dimsBackgroundDuringPresentation = true
        self.navigationItem.searchController = searchBarController
        searchBarController!.hidesNavigationBarDuringPresentation = false
        
        //Set searchBar:
        searchBar.delegate = self
        searchBar.placeholder = "Search here..."
        searchBar.sizeToFit()
        searchBar.tintColor = UIColor(hex: 0x414B6B)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else { return }
        
        // Filter the data array and get only those nodes that match the search text.
        filteredReadingList = self.readingListNodes.filter({ (node) -> Bool in
            let nodeTitle: NSString = node.title as NSString
            
            return (nodeTitle.range(of: searchString, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let search = searchBar.text {
            if search != "" {
                shouldShowSearchResults = true
            } else {
                shouldShowSearchResults = false
            }
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        
        searchBarController!.searchBar.resignFirstResponder()
    }

}
