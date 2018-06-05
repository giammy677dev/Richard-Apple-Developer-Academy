//
//  CategoryTableViewCell.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 04/06/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet var categoriesButtonArray: [UIButton]!
    @IBOutlet weak var categoryTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Set background properties:
        backgroundImage.layer.zPosition = 0
        // Set category text field properties:
        categoryTextField.placeholder = "Choose a Category"
        categoryTextField.borderStyle = .roundedRect
        categoryTextField.setLeftPaddingPoints(10)
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
        case "Education":
            categoryTextField.text = "Education"
        case "Entertainment":
            categoryTextField.text = "Entertainment"
        case "Food":
            categoryTextField.text = "Food"
        case "Travel":
            categoryTextField.text = "Travel"
        case "Lifestyle":
            categoryTextField.text = "Lifestyle"
        case "Hobby":
            categoryTextField.text = "Hobby"
        case "Sport":
            categoryTextField.text = "Sport"
        case "News":
            categoryTextField.text = "News"
        case "Health":
            categoryTextField.text = "Health"
        case "Other":
            categoryTextField.text = "Other"
        case "Technology":
            categoryTextField.text = "Technology"
        default:
            debugPrint("Error on chose category!")
        }
    }
    
}
