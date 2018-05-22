//
//  BoilerpipeRequestStructure.swift
//  Safari Extension
//
//  Created by Andrea Belcore on 22/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation

public struct BoilerpipeAnswer: Codable {
    var response: BoilerpipeResponse
    var status: String = ""
    public init(){
        response = BoilerpipeResponse()
        status = "failure"
    }
    public mutating func extractFromData(_ data: Data){
        do{
            let json = try JSONDecoder().decode(BoilerpipeAnswer.self, from: data)
            self = json
            print("STATUS: \(status)","WORD COUNT: \(response.content.words.count)")
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
}

public struct BoilerpipeResponse: Codable{
    var title: String = ""
    var content: String = ""
    var source: String = ""
    public init(){
        title = ""
        content = ""
        source = ""
    }
}


