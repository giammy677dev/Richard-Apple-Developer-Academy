//
//  NetworkManager.swift
//  Safari Extension
//
//  Created by Andrea Belcore on 22/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import Foundation
struct URLResponse{
    var fetchedData: Data?
    var success: Bool = false
    var error: Error?
}

open class NetworkManager{
    
    func httpRequest(url: URL, dataHandlerOnCompletion: @escaping (Data) -> Void) {
        print(url)
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        let request = URLRequest(url: url)
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                print("error: \(String(describing: error?.localizedDescription))")
                return
            }
            
            guard let unwrappedData = data else {
                print("Data error")
                return
            }
            
            dataHandlerOnCompletion(unwrappedData)
            
            
        })
        task.resume()
    }
    
    
}
