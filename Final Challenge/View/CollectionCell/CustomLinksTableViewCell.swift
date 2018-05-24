//
//  CustomLinksTableViewCell.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 24/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class CustomLinksTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var readingTimeLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.contentView.layer.borderColor = UIColor(hex: 0xCEDFF3).cgColor
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func checkButtonTapped(_ sender: UIButton) {

        //Modify the image of the checkButton basing on its state
        if checkButton.isSelected == false  {
            sender.setImage(UIImage(named: "Checkmark"), for: .selected)
        }

        //Animate the checkButton
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)

        }) { (success) in
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
            }, completion: nil)
        }
    }


}
