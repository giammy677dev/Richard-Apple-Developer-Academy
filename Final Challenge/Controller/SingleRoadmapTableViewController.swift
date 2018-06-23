//
//  SingleRoadmapTableViewController.swift
//  Final Challenge
//
//  Created by Geremia De Micco on 23/06/2018.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class SingleRoadmapTableViewController: UITableViewController {

    var intCategories: [Int] = [Int]()
    var currentRoadmap: WritableRoadmap?

    //The following four lines of code defines the four color that will create the gradient for the background color
    let firstBackgroundColor = UIColor(red: 1, green: 247/255, blue: 68/255, alpha: 0.8 * 0.59)
    let secondBackgroundColor = UIColor(red: 1, green: 153/255, blue: 68/255, alpha: 0.7 * 0.59)
    let thirdBackgroundColor = UIColor(red: 252/255, green: 96/255, blue: 118/255, alpha: 1 * 0.41)
    let fourthBackgroundColor = UIColor(red: 253/255, green: 107/255, blue: 179/255, alpha: 1 * 0.41)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentRoadmap = CurrentData.shared.currentSingleRoadmap

        //General settings
        self.navigationController?.navigationBar.prefersLargeTitles = true //display large title

        setTableViewBackgroundGradient(sender: self, firstBackgroundColor, secondBackgroundColor, thirdBackgroundColor, fourthBackgroundColor) //It sets the background color
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return currentRoadmap!.steps.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSingleRoadmapID", for: indexPath) as! SingleRoadmapTableViewCell

        cell.title.text = currentRoadmap?.title
        cell.numberOfArticleLeft.text = "\((currentRoadmap?.steps.count)!) Article Left"
        cell.numberOfMinutesLeft.text = "\((currentRoadmap?.steps.count)!*20) Min Left"
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134  //global Constant
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10   //global Constant
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

}
