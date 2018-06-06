//
//  CategoryTableViewCell.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 04/06/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    // TODO: - Manage category not selcted situation

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
        categoryTextField.placeholder = "Choose a Category"
        categoryTextField.borderStyle = .roundedRect
        categoryTextField.setLeftPaddingPoints(10)
        categoryTextField.isUserInteractionEnabled = false
        // Set buttons properties:
        for button in categoriesButtonArray {
            button.layer.cornerRadius = 8
            button.backgroundColor = UIColor.white
            button.setTitleColor(UIColor.black, for: .normal)
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
            DataSupportRoadmap.shared.setCategory(Category.business)
        case "Education":
            categoryTextField.text = "Education"
            DataSupportRoadmap.shared.setCategory(Category.education)
        case "Entertainment":
            categoryTextField.text = "Entertainment"
            DataSupportRoadmap.shared.setCategory(Category.entertainment)
        case "Food":
            categoryTextField.text = "Food"
            DataSupportRoadmap.shared.setCategory(Category.food)
        case "Travel":
            categoryTextField.text = "Travel"
            DataSupportRoadmap.shared.setCategory(Category.travel)
        case "Lifestyle":
            categoryTextField.text = "Lifestyle"
            DataSupportRoadmap.shared.setCategory(Category.lifestyle)
        case "Hobby":
            categoryTextField.text = "Hobby"
            DataSupportRoadmap.shared.setCategory(Category.hobby)
        case "Sport":
            categoryTextField.text = "Sport"
            DataSupportRoadmap.shared.setCategory(Category.sport)
        case "News":
            categoryTextField.text = "News"
            DataSupportRoadmap.shared.setCategory(Category.news)
        case "Health":
            categoryTextField.text = "Health"
            DataSupportRoadmap.shared.setCategory(Category.health)
        case "Other":
            categoryTextField.text = "Other"
            DataSupportRoadmap.shared.setCategory(Category.other)
        case "Technology":
            categoryTextField.text = "Technology"
            DataSupportRoadmap.shared.setCategory(Category.technology)
        default:
            DataSupportRoadmap.shared.setCategory()
        }
    }

}
