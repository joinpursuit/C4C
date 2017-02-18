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
    let endpoint: String = "https://data.cityofnewyork.us/resource/fhrw-4uyv.json"
    
    //MARK: - Initializer
    private init() {}
    
    //MARK: - Methods
    func getData(endPoint: String = self.endpoint, callback: @escaping (Data?) -> Void) {
        guard let myURL = URL(string: endPoint) else { return }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: myURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error during session: \(error)")
            }
            guard let validData = data else { return }
            
            callback(validData)
            }.resume()
    }
}
