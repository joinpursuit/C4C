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
    
    let endpoint = "https://data.cityofnewyork.us/resource/fhrw-4uyv.json?$where=created_date between '2017-01-18' and '2017-02-18'&community_board=03 QUEENS&complaint_type=Illegal Parking&$limit=50000".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    
    var regionCalculations: (minLat: CLLocationDegrees, minLong: CLLocationDegrees, maxLat: CLLocationDegrees, maxLong: CLLocationDegrees)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    
    func setup() {
        APIRequestManager.manager.getData(endPoint: self.endpoint) { (data: Data?) in
            if let unwrappedData = data {
                self.requests = ServiceRequest.getServiceRequests(data: unwrappedData)!
                DispatchQueue.main.async {
                    self.setMapPins()
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
    
    
    // MARK: - Mapview
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let myAnnotation = view.annotation {

        }
        
            
//            let myObject = myAnnotation.managedObject,
//            let indexPath = fetchedResultsController.indexPath(forObject: myObject) {
//            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
//            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)

    }
    
    func positionMap(to indexPath: IndexPath, radius: Double) {
        let request = requests[indexPath.row]
        guard let locationCoordinates = request.coordinates else { return }
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(locationCoordinates, radius, radius), animated: true)
        
//        for annotaion in mapView.annotations {
//            if let myAnnotaion = annotaion as? MKPointAnnotation {
//               
//            }
//        }
    }
    
    // MARK: - Helper functions
    
    func setMapPins() {
        mapView.removeAnnotations(mapView.annotations)
        for request in requests {
            guard let coordinates = request.coordinates else { continue }
            let pinAnnotation = MKPointAnnotation()
            pinAnnotation.title = request.descriptor
            pinAnnotation.subtitle = request.createdDate
            pinAnnotation.coordinate = coordinates
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
        }
        setMapRegion()
    }
    
    func setMapRegion() {
        let midLat = ((regionCalculations?.maxLat)! + (regionCalculations?.minLat)!) / 2
        let midLong = ((regionCalculations?.maxLong)! + (regionCalculations?.minLong)!) / 2
        let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(midLat), longitude: CLLocationDegrees(midLong))
        
        let latSpan = (regionCalculations?.maxLat)! - (regionCalculations?.minLat)!
        let longSpan = (regionCalculations?.maxLong)! - (regionCalculations?.minLong)!
        
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(latSpan), longitudeDelta: CLLocationDegrees(longSpan))
        
        let mkCoordinateRegion = MKCoordinateRegion(center: center, span: span)
        
        self.mapView.setRegion(mkCoordinateRegion, animated: true)
    }
}
