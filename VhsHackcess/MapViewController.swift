//
//  MapViewController.swift
//  VhsHackcess
//
//  Created by Sabrina Ip on 2/17/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import MapKit
import GEOSwift

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBoundry()
    }

    // MARK: - Actions
    
    @IBAction func filterTapped(_ sender: UIBarButtonItem) {
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
    }
    
    func addBoundry() {
//        if let geoJSONURL = Bundle.main.url(forResource: "Community Districts", withExtension: "geojson") {
//            do {
//                let geometries = try Geometry.fromGeoJSON(geoJSONURL)
//                if let geo = geometries?[0] as? MultiPolygon {
//                    
//                    if let shapesCollection = geo.mapShape() as? MKShapesCollection {
//                        
//                        let shapes = shapesCollection.shapes
//                        
//                        for shape in shapes {
//                            if let polygon = shape as? MKPolygon {
//                                mapView.add(polygon)
//                            }
//                        }
//                    }
//                    
//                }
//            } catch {
//                print("Unable to load geojson data")
//            }
//        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    /*
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
}
