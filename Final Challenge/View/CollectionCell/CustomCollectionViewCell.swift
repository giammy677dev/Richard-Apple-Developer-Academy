//
//  CustomCollectionViewCell.swift
//  Final Challenge
//
//  Created by Geremia De Micco on 22/05/18.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var minutesLeftLabel: UILabel!
    @IBOutlet weak var seeAllLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var delegate: MyCustomCellDelegator!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        linkLabel.textColor = UIColor(hex: 0xFE979C)
        minutesLeftLabel.textColor = UIColor(hex: 0x90A4B7)

        let gradient = CAGradientLayer()

        gradient.frame = self.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.white.cgColor]

        self.layer.insertSublayer(gradient, at: 0)
        self.alpha = 0.8
        self.layer.cornerRadius = 9

    }

}
