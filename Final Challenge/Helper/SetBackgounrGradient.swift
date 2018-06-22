//
//  SetBackgounrGradient.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 22/06/2018.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

//This function creates the gradient for the background with four colors
public extension UITableViewController {
    func setTableViewBackgroundGradient(sender: UITableViewController, _ firstColor: UIColor, _ secondColor: UIColor, _ thirdColor: UIColor, _ fourthColor: UIColor) {

        let gradientBackgroundColors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor, fourthColor.cgColor]
        let gradientLocations = [0.0, 0.25]

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = gradientLocations as [NSNumber]

        gradientLayer.frame = sender.tableView.bounds
        let backgroundView = UIView(frame: sender.tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        sender.tableView.backgroundView = backgroundView
    }
}
