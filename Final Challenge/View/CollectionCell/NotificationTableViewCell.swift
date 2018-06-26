//
//  NotificationTableViewCell.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 05/06/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var switchButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Set style:
        whiteView.layer.cornerRadius = 4
        // TODO: - Manage switch
        switchButton.isSelected = true
        switchButton.setImage(UIImage(named: "switchOn"), for: .selected)
        switchButton.setImage(UIImage(named: "switchOff"), for: .normal)
    }

    @IBAction func changeButtonStatus(_ sender: UIButton) {
        if switchButton.isSelected == true {
            switchButton.isSelected = !switchButton.isSelected
            DataSupportRoadmap.shared.setNotification(true)
        } else {
            switchButton.isSelected = !switchButton.isSelected
            DataSupportRoadmap.shared.setNotification(false)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
