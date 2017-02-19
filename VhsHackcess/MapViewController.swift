//
//  MapViewController.swift
//  VhsHackcess
//
//  Created by Sabrina Ip on 2/17/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mapViewBottomConstraint: NSLayoutConstraint!
    
    var requests: [ServiceRequest] = []
    
    var endpoint: String!
    
    var regionCalculations: (minLat: CLLocationDegrees, minLong: CLLocationDegrees, maxLat: CLLocationDegrees, maxLong: CLLocationDegrees)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setup()
    }
    
    // MARK: - Setup
    
    func setup() {
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        
        APIRequestManager.manager.getData(endPoint: self.endpoint) { (data: Data?) in
            if let unwrappedData = data {
                self.requests = ServiceRequest.getServiceRequests(data: unwrappedData)!
                DispatchQueue.main.async {
                    self.setMapPinAndRegion()
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Actions
    
    @IBAction func filterTapped(_ sender: UIBarButtonItem) {
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintDetails", for: indexPath) as! ComplaintDetailsTableViewCell
        let request = requests[indexPath.row]
        cell.descriptorLabel.text = request.descriptor
        cell.timeAndDateLabel.text = request.createdDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        positionMap(to: indexPath, radius: 4000.0)
    }
    
    // MARK: - Mapview
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let myAnnotation = view.annotation as? RequestMKPointAnnotation {
            let index = myAnnotation.index
            tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: true)
            tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .top)
        }
    }
    
    func positionMap(to indexPath: IndexPath, radius: Double) {
        let request = requests[indexPath.row]
        guard let locationCoordinates = request.coordinates else { return }
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(locationCoordinates, radius, radius), animated: true)
        for annotaion in mapView.annotations {
            if let myAnnotaion = annotaion as? RequestMKPointAnnotation {
                if myAnnotaion.index == indexPath.row {
                    mapView.selectAnnotation(myAnnotaion, animated: true)
                }
            }
        }
    }
    
    func setMapPinAndRegion() {
        mapView.removeAnnotations(mapView.annotations)
        for (index, request) in requests.enumerated() {
            guard let coordinates = request.coordinates else { continue }
            
            let pinAnnotation = RequestMKPointAnnotation()
            pinAnnotation.coordinate = coordinates
            pinAnnotation.title = request.descriptor
            pinAnnotation.subtitle = request.createdDate
            pinAnnotation.index = index
            mapView.addAnnotation(pinAnnotation)
            
            if let calc = regionCalculations {
                if coordinates.latitude < calc.minLat {
                    regionCalculations?.minLat = coordinates.latitude
                }
                if coordinates.latitude > calc.maxLat {
                    regionCalculations?.maxLat = coordinates.latitude
                }
                if coordinates.longitude < calc.minLong {
                    regionCalculations?.minLong = coordinates.longitude
                }
                if coordinates.longitude > calc.maxLong {
                    regionCalculations?.maxLong = coordinates.longitude
                }
            } else {
                regionCalculations = (minLat: coordinates.latitude, minLong: coordinates.longitude, maxLat: coordinates.latitude, maxLong: coordinates.longitude)
            }
            
            guard let calc = regionCalculations else { return }
            
            let midLat = (calc.maxLat + calc.minLat) / 2
            let midLong = (calc.maxLong + calc.minLong) / 2
            let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(midLat), longitude: CLLocationDegrees(midLong))
            
            let latSpan = calc.maxLat - calc.minLat
            let longSpan = calc.maxLong - calc.minLong
            
            let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(latSpan), longitudeDelta: CLLocationDegrees(longSpan))
            
            let mkCoordinateRegion = MKCoordinateRegion(center: center, span: span)
            
            self.mapView.setRegion(mkCoordinateRegion, animated: true)
        }
    }
}
