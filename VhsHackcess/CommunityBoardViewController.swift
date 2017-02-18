//
//  CommunityBoardViewController.swift
//  VhsHackcess
//
//  Created by Sabrina Ip on 2/17/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import GEOSwift
import MapKit

class CommunityBoardViewController: UIViewController {

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var infoTextView: UITextView!
    
    var districts = [String]()
    var geometries: [Geometry]? = [Geometry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGeometries()
    }

    // MARK: - Actions
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func getDataTapped(_ sender: UIButton) {
    }
    
    // MARK: - TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    
    func getGeometries() {
        guard let geoJSONURL = Bundle.main.url(forResource: "Community Districts", withExtension: "geojson"),
            let jsonData = try? Data(contentsOf: geoJSONURL) else { return }
        
        do {
            let parsedObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            guard let parsedObjectCasted = parsedObject as? [String: Any],
                let features = parsedObjectCasted["features"] as? [[String: Any]] else {
                    return
            }
            
            for each in features {
                guard let properties = each["properties"] as? [String:Any] else { continue }
                if let boroCd = properties["boro_cd"] as? String {
                    districts.append(boroCd)
                }
            }
        } catch {
            print(error)
        }
        
        do {
            let geometries = try Geometry.fromGeoJSON(geoJSONURL)
            self.geometries = geometries
        }
        catch {
            print(error)
        }
    }
}
