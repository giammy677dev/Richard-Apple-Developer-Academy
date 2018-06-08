//
//  SeeAllTableViewCell.swift
//  Final Challenge
//
//  Created by Geremia De Micco on 29/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class SeeAllTableViewCell: UITableViewCell {

    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var numberOfTotalStep: UILabel!
    @IBOutlet weak var numberOfStepCompleted: UILabel!
    @IBOutlet weak var titleRoadmap: UILabel!
    @IBOutlet weak var articlesLeft: UILabel!
    @IBOutlet weak var minutesLeft: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
