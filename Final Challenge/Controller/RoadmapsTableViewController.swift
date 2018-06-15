//
//  RoadmapsTableViewController.swift
//  Final Challenge
//
//  Created by Geremia De Micco on 21/05/18.
//

import UIKit

class RoadmapsTableViewController: UITableViewController {

    var roadmaps: [WritableRoadmap] = DatabaseInterface.shared.loadRoadmaps() ?? [WritableRoadmap]()
    var intCategories: [Int] = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        //General settings
        self.navigationController?.navigationBar.prefersLargeTitles = true //display large title

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!) //set the background color

        if !roadmaps.isEmpty {
            roadmaps = roadmaps.sorted { (roadmapOne, roadmapTwo) -> Bool in
                return roadmapOne.category.rawValue < roadmapTwo.category.rawValue
            }
        }

//        let customCell = UINib(nibName: "collectionViewCell", bundle: nil)
//        self.tableView.register(customCell, forCellReuseIdentifier: "collectionViewCell")

//        let headerCustomCell = UINib(nibName: "headerCell", bundle: nil)
//        self.tableView.register(headerCustomCell, forCellReuseIdentifier: "headerCell")
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return countCategories()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let collectionCell = tableView.dequeueReusableCell(withIdentifier: "collectionViewCell", for: indexPath) as! CollectionTableViewCell

        collectionCell.delegate = self

        collectionCell.backgroundView = UIImageView(image: UIImage(named: "Background celle.png")!) //It sets the background of the table view rows

        return collectionCell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("HeaderTableViewCell", owner: self, options: nil)?.first as! HeaderTableViewCell

        header.headerLabel.text = stringFromCategory(intCategories[section])
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

    private func countCategories() -> Int {
        var number: Int = 0
        var precedent: Int = -1
        for elem in roadmaps {
            if elem.category.rawValue != precedent {
                number = number + 1
                precedent = Int(elem.category.rawValue)
                intCategories.append(precedent)
            }
        }
        return number
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
    func callSegueFromCell(identifier: String) {
        print("Ciao")
        self.performSegue(withIdentifier: identifier, sender: self)
    }
}
