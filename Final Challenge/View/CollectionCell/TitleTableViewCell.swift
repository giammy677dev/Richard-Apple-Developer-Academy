//
//  TitleTableViewCell.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 29/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var titleTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        titleTextField.placeholder = "Add title"
        titleTextField.borderStyle = .roundedRect
        titleTextField.setLeftPaddingPoints(10)
        titleTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func textFieldShouldReturn(titleTextField: UITextField) -> Bool {
        titleTextField.endEditing(true)
        return true
    }

    func textFieldShouldReturn(titleTextField: UITextField!) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
}
