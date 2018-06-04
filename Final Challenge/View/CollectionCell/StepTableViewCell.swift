//
//  StepTableViewCell.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 29/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class StepTableViewCell: UITableViewCell {
    @IBOutlet weak var stepTitleLabel: UILabel!
    @IBOutlet weak var readingTimeLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
