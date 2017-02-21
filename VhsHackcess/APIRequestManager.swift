//
//  APIRequestManager.swift
//  VhsHackcess
//
//  Created by Harichandan Singh on 2/18/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

class APIRequestManager {
    //MARK: - Properties
    static let manager = APIRequestManager()
    
    //MARK: - Initializer
    private init() {}
    
    //MARK: - Methods
    func getData(endPoint: String, callback: @escaping (Data?) -> Void) {
        guard let myURL = URL(string: endPoint) else { return }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        print("Endpoint: \(endPoint)")
        
        session.dataTask(with: myURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error retrieving data: \(error)")
            }
            guard let validData = data else { return }
            
            callback(validData)
            
            }.resume()
    }
}
