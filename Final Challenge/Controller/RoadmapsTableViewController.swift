//
//  RoadmapsTableViewController.swift
//  Final Challenge
//
//  Created by Geremia De Micco on 21/05/18.
//

import UIKit
import SafariServices

class RoadmapsTableViewController: UITableViewController {

//    var roadmaps: [WritableRoadmap] = DatabaseInterface.shared.loadRoadmaps() ?? [WritableRoadmap]()
    var intCategories: [Int] = [Int]()

    //The following four lines of code defines the four color that will create the gradient for the background color
    let firstBackgroundColor = UIColor(red: 1, green: 247/255, blue: 68/255, alpha: 0.8 * 0.59)
    let secondBackgroundColor = UIColor(red: 1, green: 153/255, blue: 68/255, alpha: 0.7 * 0.59)
    let thirdBackgroundColor = UIColor(red: 252/255, green: 96/255, blue: 118/255, alpha: 1 * 0.41)
    let fourthBackgroundColor = UIColor(red: 253/255, green: 107/255, blue: 179/255, alpha: 1 * 0.41)

    override func viewDidLoad() {
        super.viewDidLoad()
        CurrentData.shared.load()
        //General settings
        self.navigationController?.navigationBar.prefersLargeTitles = true //display large title

        setTableViewBackgroundGradient(sender: self, firstBackgroundColor, secondBackgroundColor, thirdBackgroundColor, fourthBackgroundColor) //It sets the background color

        //The following 3 lines of code declare and present the searchBar
        let searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchResultsUpdater = self as? UISearchResultsUpdating
        self.navigationItem.searchController = searchBar
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return CurrentData.shared.currentCategories.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let collectionCell = tableView.dequeueReusableCell(withIdentifier: "collectionViewCell", for: indexPath) as! CollectionTableViewCell

        collectionCell.category = Int(CurrentData.shared.currentCategories[indexPath.section].rawValue)
        collectionCell.delegate = self      //delegate to use self.delegate.callSegueFromCell(identifier: "SeeAllSegue")
        collectionCell.backgroundColor = UIColor.clear

        return collectionCell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("HeaderTableViewCell", owner: self, options: nil)?.first as! HeaderTableViewCell

        header.headerLabel.text = self.stringFromCategory(Int(CurrentData.shared.currentCategories[section].rawValue))

        header.backgroundColor = UIColor(red: 253/255, green: 253/255, blue: 253/255, alpha: 0.35)

        return header
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225  //global Constant
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 71   //global Constant
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    private func stringFromCategory(_ rawValue: Int) -> String {
        switch rawValue {
        case 0:
            return "Business"
        case 1:
            return "Education"
        case 2:
            return "Entertainment"
        case 3:
            return "Food"
        case 4:
            return "Travel"
        case 5:
            return "Lifestyle"
        case 6:
            return "Hobby"
        case 7:
            return "Sport"
        case 8:
            return "News"
        case 9:
            return "Health"
        case 10:
            return "Other"
        case 11:
            return "Technology"
        default:
            return "Other"
        }
    }
}

extension RoadmapsTableViewController: MyCustomCellDelegator {
    func callSVC(svc: SFSafariViewController) {
        self.present(svc, animated: true, completion: nil)
    }

    func callSegueFromCell(identifier: String) {
        self.performSegue(withIdentifier: identifier, sender: self)
    }
}
