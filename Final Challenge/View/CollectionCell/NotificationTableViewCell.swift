//
//  NotificationTableViewCell.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 05/06/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    var notificationOn: Bool = true
    
    @IBOutlet weak var switchController: UISwitch!
    @IBOutlet weak var whiteView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Set style:
        whiteView.layer.cornerRadius = 4
        // TODO: - Manage switch
        switchController.setOn(true, animated: false)
        switchController.addTarget(self, action: #selector(changeStatus(_:)), for: .touchUpInside)
    }
    
    @objc func changeStatus(_ sender: UISwitch) {
        if sender.isOn {
            self.notificationOn = true
        } else {
            self.notificationOn = false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
