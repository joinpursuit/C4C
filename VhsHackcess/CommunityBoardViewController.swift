//
//  CommunityBoardViewController.swift
//  VhsHackcess
//
//  Created by Sabrina Ip on 2/17/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import MapKit

class CommunityBoardViewController: UIViewController {

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var infoTextView: UITextView!
    
    // var districts: [(boroCd: String, polygon: MKPolygon)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    /* NOT USING THESE FUNCTIONS IF VIC'S GET REQUEST WORKS
    func getDistricts() {
        guard let geoJSONURL = Bundle.main.url(forResource: "Community Districts", withExtension: "geojson"),
            let jsonData = try? Data(contentsOf: geoJSONURL) else { return }
        
        do {
            let parsedObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            guard let parsedObjectCasted = parsedObject as? [String: Any],
                let features = parsedObjectCasted["features"] as? [[String: Any]] else {
                    return
            }
            
            for each in features {
                guard let properties = each["properties"] as? [String:Any],
                    let boroCd = properties["boro_cd"] as? String else { continue }
                
                guard let geometry = each["geometry"] as? [String: AnyObject],
                    let coord = geometry["coordinates"] as? [[[[Double]]]] else { continue }
                let coordinatesArray = coord[0][0]

                var coordinates: [MKMapPoint] = []
                for coordinate in coordinatesArray {
                    let mkMapPoint = MKMapPoint(x: coordinate[0], y: coordinate[1])
                    coordinates.append(mkMapPoint)
                }
                
                let bufferPointer = UnsafeBufferPointer(start: coordinates, count: coordinates.count)
                var polygon = MKPolygon(points: bufferPointer.baseAddress!, count: coordinates.count)
                
                let district = (boroCd, polygon)
                districts.append(district)
            }
        } catch {
            print(error)
        }
    }
    
    func isInsidePolygon(point: MKMapPoint, polygon: MKPolygon) -> Bool {
        return true
    }
 */
}
