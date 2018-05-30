//
//  LinksTableViewController.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 24/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class LinksTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Invoke xib
        let customCell = UINib(nibName: "CustomLinksTableViewCell", bundle: nil)
        self.tableView.register(customCell, forCellReuseIdentifier: "CustomLinksTableViewCell")

        //General settings
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none //Delete the separator line between each rows of the tableView
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!) //set the background color
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomLinksTableViewCell", for: indexPath) as! CustomLinksTableViewCell

        cell.selectionStyle = .none //It is needed to prevent that the cells are highlighted and not only selected

//        cell.shadowView.clipsToBounds = false
//        cell.shadowView.layer.shadowColor = UIColor.black.cgColor
//        cell.shadowView.layer.shadowOpacity = 1
//        cell.shadowView.layer.shadowOffset = CGSize.zero
//        cell.shadowView.layer.shadowRadius = 3
//
//        cell.footerShadowView.clipsToBounds = false
//        cell.footerShadowView.layer.shadowColor = UIColor.black.cgColor
//        cell.footerShadowView.layer.shadowOpacity = 1
//        cell.footerShadowView.layer.shadowOffset = CGSize.zero
//        cell.footerShadowView.layer.shadowRadius = 3

//        cell.containerView.clipsToBounds = false
//        cell.containerView.layer.shadowColor = UIColor.black.cgColor
//        cell.containerView.layer.shadowOpacity = 1
//        cell.containerView.layer.shadowOffset = CGSize.zero
//        cell.containerView.layer.shadowRadius = 10
//        cell.containerView.layer.shadowPath = UIBezierPath(roundedRect: cell.containerView.bounds, cornerRadius: 10).cgPath
//        cell.footerImageView.clipsToBounds = true
//        cell.footerImageView.layer.cornerRadius = 10

        //Get the last cells in the tableView
        let totalRow = tableView.numberOfRows(inSection: indexPath.section)
        //first get total rows in that section by current indexPath.
//        if indexPath.row == totalRow - 1 {
//            cell.footerImageView.alpha = 0
//        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }

}
