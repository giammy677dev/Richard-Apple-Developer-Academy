//
//  SingleNodeTableViewCell.swift
//  Final Challenge
//
//  Created by Geremia De Micco on 24/06/2018.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class SingleNodeTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var numberOfArticleLeft: UILabel!
    @IBOutlet weak var numberOfMinutesLeft: UILabel!
    @IBOutlet weak var view: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.view.tintColor = UIColor.clear
        self.view.backgroundColor = UIColor.clear
        self.view.layer.cornerRadius = 9
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
