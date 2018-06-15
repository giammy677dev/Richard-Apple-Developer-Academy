//
//  ResearchesTableViewController.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 23/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class ResourcesTableViewController: UITableViewController, MyCustomCellDelegator {

    override func viewDidLoad() {
        super.viewDidLoad()

        //General settings
        self.navigationController?.navigationBar.prefersLargeTitles = true //display large title

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!) //set the background color
    }

    override func viewWillAppear(_ animated: Bool) {
        CurrentData.shared.readingListByTags = [(String, [Node])]()
        loadResourcesFromDatabase()
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return CurrentData.shared.readingListByTags.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let collectionCell = tableView.dequeueReusableCell(withIdentifier: "collectionViewCell", for: indexPath) as! CollectionTableViewCell

        collectionCell.delegate = self
//        collectionCell.dataSource = (self as! MyCustomCellDataSource)

        collectionCell.backgroundView = UIImageView(image: UIImage(named: "Background celle.png")!) //It sets the background of the table view rows

        let content = CurrentData.shared.readingListByTags[indexPath.section].nodes
//        collectionCell.content = content

        return collectionCell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("HeaderTableViewCell", owner: self, options: nil)?.first as! HeaderTableViewCell
        if section == 0 {
            header.headerLabel.text = CurrentData.shared.readingListByTags[section].tag
        } else {
        header.headerLabel.text = "#" + CurrentData.shared.readingListByTags[section].tag
        }

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

    func callSegueFromCell(identifier: String) {
        self.performSegue(withIdentifier: identifier, sender: self)
    }

    func loadResourcesFromDatabase() {
        let controller = CoreDataController.shared
        guard let coreDataReadingListRoadmap = controller.fetchCDRoadmap(uuid: K.readingListRoadmapID) else {
            debugPrint("[CDERROR] No reading list found")
            return
        }
        let readingListRoadmap = controller.getEntireRoadmapFromRecord(coreDataReadingListRoadmap)
        print(readingListRoadmap.steps)
        let readingListStep = readingListRoadmap.steps[0]
        print(readingListStep.nodes)
        let readingListNodes = readingListStep.nodes
//        print(readingListNodes![0].title)

        let recentNodes = readingListNodes?.sorted(by: {(node1, node2) in
            return node1.creationTimestamp < node2.creationTimestamp
        })

        var tags = Set<String>()
        for node in recentNodes! {
            tags = tags.union(node.tags)
        }

        let tagArray = tags.sorted()

        CurrentData.shared.readingListByTags.append(("Recent", recentNodes!))

        for tag in tagArray {
            var group = [String: [Node]]()
            group[tag] = [Node]()
            for node in recentNodes! {
                if node.tags.contains(tag) {
                    group[tag]?.append(node)
                }
            }
            CurrentData.shared.readingListByTags.append((tag, group[tag]!))

        }

//        print(controller.fetchCDNodes()![0].parentsStep)

    }

}
