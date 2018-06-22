//
//  AddStepTableViewCell.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 05/06/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class AddStepTableViewCell: UITableViewCell {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addResourceButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        titleTextField.placeholder = "What is the first step?"
        titleTextField.borderStyle = .roundedRect
        titleTextField.setLeftPaddingPoints(10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
