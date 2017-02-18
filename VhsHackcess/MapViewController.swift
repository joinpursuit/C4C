//
//  MapViewController.swift
//  VhsHackcess
//
//  Created by Sabrina Ip on 2/17/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mapViewBottomConstraint: NSLayoutConstraint!
    
    var placeholderComplaints: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions
    
    @IBAction func filterTapped(_ sender: UIBarButtonItem) {
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
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
    
    // MARK: - Helper functions
    
    func setMapPins() {
        mapView.removeAnnotations(mapView.annotations)
        for object in placeholderComplaints {
            let pinAnnotation = MKPointAnnotation()
            pinAnnotation.title = "placeholder title"
            pinAnnotation.subtitle = "placeholder date and time"
            // pinAnnotation.coordinate = object.location.coordinate
            mapView.addAnnotation(pinAnnotation)
        }
    }
}
