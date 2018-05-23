//
//  StringExtensions.swift
//  Safari Extension
//
//  Created by Andrea Belcore on 23/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation

extension String {
    var words: [String] {
        var words: [String] = []
        enumerateSubstrings(in: startIndex..<endIndex, options: .byWords) { word,_,_,_ in
            guard let word = word else { return }
            words.append(word)
        }
        return words
    }
}
