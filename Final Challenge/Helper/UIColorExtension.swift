//
//  UIColorExtension.swift
//  Final Challenge
//
//  Created by Gian Marco Orlando on 24/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

//Extension of UIColor to set color through hex
public extension UIColor {
    convenience public init(hex: UInt) {
        let components = (
            r: CGFloat((hex >> 16) & 0xff) / 255,
            g: CGFloat((hex >> 08) & 0xff) / 255,
            b: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.r, green: components.g, blue: components.b, alpha: 1)
    }
}
