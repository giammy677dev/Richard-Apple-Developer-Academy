//
//  File.swift
//  Final Challenge
//
//  Created by Andrea Belcore on 29/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation

extension Array {
    func safeCall(_ i:Int) -> Array.Element? {
        return 0 <= i && i < count ? self[i] : nil
    }
}

