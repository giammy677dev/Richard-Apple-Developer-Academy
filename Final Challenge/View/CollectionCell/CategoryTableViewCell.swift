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
    var chosedCategory: Category? // Move this variable on a singleton (?!)

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
        // TODO: Define activities
        switch selector.titleLabel?.text {
        case "Business":
            categoryTextField.text = "Business"
            chosedCategory = Category.Business
        case "Education":
            categoryTextField.text = "Education"
            chosedCategory = Category.Education
        case "Entertainment":
            categoryTextField.text = "Entertainment"
            chosedCategory = Category.Entertainment
        case "Food":
            categoryTextField.text = "Food"
            chosedCategory = Category.Food
        case "Travel":
            categoryTextField.text = "Travel"
            chosedCategory = Category.Travel
        case "Lifestyle":
            categoryTextField.text = "Lifestyle"
            chosedCategory = Category.Lifestyle
        case "Hobby":
            categoryTextField.text = "Hobby"
            chosedCategory = Category.Hobby
        case "Sport":
            categoryTextField.text = "Sport"
            chosedCategory = Category.Sport
        case "News":
            categoryTextField.text = "News"
            chosedCategory = Category.News
        case "Health":
            categoryTextField.text = "Health"
            chosedCategory = Category.Health
        case "Other":
            categoryTextField.text = "Other"
            chosedCategory = Category.Other
        case "Technology":
            categoryTextField.text = "Technology"
            chosedCategory = Category.Technology
        default:
            chosedCategory = nil
        }
    }

}
