//
//  AddResourceTableViewCell.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 27/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class AddResourceTableViewCell: UITableViewCell {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var URLTextField: UITextField!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialiation code
        titleTextField.placeholder = "Add title"
        titleTextField.borderStyle = .roundedRect
        URLTextField.placeholder = "Add URL"
        URLTextField.borderStyle = .roundedRect
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
