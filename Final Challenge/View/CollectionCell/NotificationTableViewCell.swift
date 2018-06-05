//
//  NotificationTableViewCell.swift
//  Final Challenge
//
//  Created by Amerigo Buonocore on 05/06/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var switchSelector: UIView!
    @IBOutlet weak var whiteView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Set style:
        whiteView.layer.cornerRadius = 4
        // TODO: - Manage switch
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
