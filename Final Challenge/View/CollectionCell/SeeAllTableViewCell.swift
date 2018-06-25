//
//  SeeAllTableViewCell.swift
//  Final Challenge
//
//  Created by Geremia De Micco on 29/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class SeeAllTableViewCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var articleLeft: UILabel!
    @IBOutlet weak var minLeft: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.view.layer.cornerRadius = 9
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
