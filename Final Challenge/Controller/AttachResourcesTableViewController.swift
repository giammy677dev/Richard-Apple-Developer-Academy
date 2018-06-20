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
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    @objc func done() {
        print("done")
    }
}
