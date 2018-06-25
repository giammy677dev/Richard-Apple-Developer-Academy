//
//  SeeAllTableViewController.swift
//  Final Challenge
//
//  Created by Geremia De Micco on 29/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class SeeAllTableViewController: UITableViewController {

    var catergory: Int?
    var roadmaps: [Roadmap]?

    //The following four lines of code defines the four color that will create the gradient for the background color
    let firstBackgroundColor = UIColor(red: 1, green: 247/255, blue: 68/255, alpha: 0.8 * 0.59)
    let secondBackgroundColor = UIColor(red: 1, green: 153/255, blue: 68/255, alpha: 0.7 * 0.59)
    let thirdBackgroundColor = UIColor(red: 252/255, green: 96/255, blue: 118/255, alpha: 1 * 0.41)
    let fourthBackgroundColor = UIColor(red: 253/255, green: 107/255, blue: 179/255, alpha: 1 * 0.41)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.catergory = CurrentData.shared.currentSeeAllCategory
        self.roadmaps = CurrentData.shared.roadmapsForCategory(category: Category(rawValue: Int16(self.catergory!))!)
        //General settings
        self.tableView.separatorColor = UIColor.clear
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!) //set the background color
        setTableViewBackgroundGradient(sender: self, firstBackgroundColor, secondBackgroundColor, thirdBackgroundColor, fourthBackgroundColor) //It sets the background color
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (self.roadmaps?.count)!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "singleRoadmap", for: indexPath) as! SeeAllTableViewCell

        cell.title.text = self.roadmaps![indexPath.section].title
        cell.articleLeft.text = "\(self.roadmaps![indexPath.section].steps.count) article left"
        cell.minLeft.text = "\(self.roadmaps![indexPath.section].steps.count * 20) minutes left"

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175  //global Constant
    }

}
