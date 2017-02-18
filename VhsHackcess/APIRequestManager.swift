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
    let endpoint = "https://data.cityofnewyork.us/resource/fhrw-4uyv.json?$where=created_date between '2017-01-18' and '2017-02-18'&community_board=03 BRONX&$limit=50000".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    
    //MARK: - Initializer
    private init() {}
    
    //MARK: - Methods
    func getData(endPoint: String, callback: @escaping (Data?) -> Void) {
        guard let myURL = URL(string: endPoint) else { return }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        print(endpoint)
        
        session.dataTask(with: myURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error retrieving data: \(error)")
            }
            guard let validData = data else { return }
        
            callback(validData)
            
            }.resume()
    }
}
