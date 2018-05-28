//
//  AddTagsTableViewCell.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 27/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class AddTagsTableViewCell: UITableViewCell {
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var firstTagButton: UIButton!
    @IBOutlet weak var secondTagButton: UIButton!
    @IBOutlet weak var thirdTagButton: UIButton!
    @IBOutlet weak var fourthTagButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tagTextField.placeholder = "#"
        tagTextField.borderStyle = .roundedRect
        tagTextField.setLeftPaddingPoints(10)
        firstTagButton.layer.cornerRadius = 8
        secondTagButton.layer.cornerRadius = 8
        thirdTagButton.layer.cornerRadius = 8
        fourthTagButton.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
