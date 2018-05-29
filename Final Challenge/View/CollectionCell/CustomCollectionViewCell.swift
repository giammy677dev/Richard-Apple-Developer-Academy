//
//  CustomCollectionViewCell.swift
//  Final Challenge
//
//  Created by Geremia De Micco on 22/05/18.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var articlesLeft: UILabel!
    @IBOutlet weak var minutesLeft: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gradient = CAGradientLayer()
        
        gradient.frame = self.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
        
        self.layer.insertSublayer(gradient, at: 0)
        self.alpha = 0.8

    }

}
