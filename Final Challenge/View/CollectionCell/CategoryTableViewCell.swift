//
//  CategoryTableViewCell.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 04/06/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    // Properties:
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet var categoriesButtonArray: [UIButton]!
    @IBOutlet weak var categoryTextField: UITextField!
    // TODO: - Manage category not selcted situation

    // Methods:
    override func awakeFromNib() {
        super.awakeFromNib()
        // Set background properties:
        backgroundImage.layer.zPosition = 0
        // Set category text field properties:
        categoryTextField.text = "Tap on a Category"
        categoryTextField.borderStyle = .roundedRect
        categoryTextField.font = UIFont(name: "Lato-Regular", size: 16)
        categoryTextField.textColor = UIColor(hex: 0x414B6B)
        categoryTextField.setLeftPaddingPoints(10)
        categoryTextField.isUserInteractionEnabled = false
        // Set buttons properties
        for button in categoriesButtonArray {
            button.layer.cornerRadius = 8
            button.backgroundColor = UIColor.white
            button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 15)
            button.setTitleColor(UIColor(hex: 0x414B6B), for: .normal)
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
            button.sizeToFit()
            button.addTarget(self, action: #selector(choseCategory(_:)), for: .touchUpInside)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func choseCategory(_ selector: UIButton) {
        switch selector.titleLabel?.text {
        case "Business":
            categoryTextField.text = "Business"
            DataSupportRoadmap.shared.setRoadmapCategory(Category.business)
        case "Education":
            categoryTextField.text = "Education"
            DataSupportRoadmap.shared.setRoadmapCategory(Category.education)
        case "Entertainment":
            categoryTextField.text = "Entertainment"
            DataSupportRoadmap.shared.setRoadmapCategory(Category.entertainment)
        case "Food":
            categoryTextField.text = "Food"
            DataSupportRoadmap.shared.setRoadmapCategory(Category.food)
        case "Travel":
            categoryTextField.text = "Travel"
            DataSupportRoadmap.shared.setRoadmapCategory(Category.travel)
        case "Lifestyle":
            categoryTextField.text = "Lifestyle"
            DataSupportRoadmap.shared.setRoadmapCategory(Category.lifestyle)
        case "Hobby":
            categoryTextField.text = "Hobby"
            DataSupportRoadmap.shared.setRoadmapCategory(Category.hobby)
        case "Sport":
            categoryTextField.text = "Sport"
            DataSupportRoadmap.shared.setRoadmapCategory(Category.sport)
        case "News":
            categoryTextField.text = "News"
            DataSupportRoadmap.shared.setRoadmapCategory(Category.news)
        case "Health":
            categoryTextField.text = "Health"
            DataSupportRoadmap.shared.setRoadmapCategory(Category.health)
        case "Other":
            categoryTextField.text = "Other"
            DataSupportRoadmap.shared.setRoadmapCategory(Category.other)
        case "Technology":
            categoryTextField.text = "Technology"
            DataSupportRoadmap.shared.setRoadmapCategory(Category.technology)
        default:
            DataSupportRoadmap.shared.setRoadmapCategory()
        }
    }
}
