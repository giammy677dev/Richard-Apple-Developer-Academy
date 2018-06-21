//
//  RoadmapsTableViewController.swift
//  Final Challenge
//
//  Created by Geremia De Micco on 21/05/18.
//

import UIKit

class RoadmapsTableViewController: UITableViewController {

//    var roadmaps: [WritableRoadmap] = DatabaseInterface.shared.loadRoadmaps() ?? [WritableRoadmap]()
    var intCategories: [Int] = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        CurrentData.shared.load()
        //General settings
        self.navigationController?.navigationBar.prefersLargeTitles = true //display large title
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!) //set the background color

//        self.view.backgroundColor = UIColor.white
//        setTableViewBackgroundGradient(sender: self, UIColor(hex: 0xFFF744), UIColor(hex: 0xFF9944), UIColor(hex: 0xFD6BB3), UIColor(hex: 0xFC6076))

//        setTableViewBackgroundGradient(sender: self, UIColor(red: 1, green: 153/255, blue: 68/255, alpha: 0.7), UIColor(red: 1, green: 247/255, blue: 68/255, alpha: 0.8), UIColor(red: 252/255, green: 96/255, blue: 118/255, alpha: 1), UIColor(red: 253/255, green: 107/255, blue: 179/255, alpha: 1))

        setTableViewBackgroundGradient(sender: self, UIColor(red: 1, green: 247/255, blue: 68/255, alpha: 0.8 * 0.59), UIColor(red: 1, green: 153/255, blue: 68/255, alpha: 0.7 * 0.59), UIColor(red: 252/255, green: 96/255, blue: 118/255, alpha: 1 * 0.41), UIColor(red: 253/255, green: 107/255, blue: 179/255, alpha: 1 * 0.41))

//        setTableViewBackgroundGradient(sender: self, UIColor(hex: 0xFF9944), UIColor(hex: 0xFD6BB3))
//        self.tableView.backgroundView?.alpha = 0.5
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

//        collectionCell.backgroundView = UIImageView(image: UIImage(named: "Background celle.png")!) //It sets the background of the table view rows

        return collectionCell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("HeaderTableViewCell", owner: self, options: nil)?.first as! HeaderTableViewCell

        header.headerLabel.text = self.stringFromCategory(Int(CurrentData.shared.currentCategories[section].rawValue))
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

    func setTableViewBackgroundGradient(sender: UITableViewController, _ firstColor: UIColor, _ secondColor: UIColor, _ thirdColor: UIColor, _ fourthColor: UIColor) {

        let gradientBackgroundColors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor, fourthColor.cgColor]
        let gradientLocations = [0.0, 0.25]

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = gradientLocations as [NSNumber]

//        gradientLayer.transform = CATransform3DMakeRotation(CGFloat.pi / 4, 0, 0, 0)

        gradientLayer.frame = sender.tableView.bounds
        let backgroundView = UIView(frame: sender.tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        sender.tableView.backgroundView = backgroundView
    }
}

extension RoadmapsTableViewController: MyCustomCellDelegator {
    func callSegueFromCell(identifier: String) {
        self.performSegue(withIdentifier: identifier, sender: self)
    }
}
