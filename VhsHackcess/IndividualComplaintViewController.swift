//
//  IndividualComplaintViewController.swift
//  VhsHackcess
//
//  Created by Sabrina Ip on 2/17/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import MapKit

class IndividualComplaintViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    var request: ServiceRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInfoLabel()
        
        //textView color scheme
        self.infoTextView.textColor = UIColor.white
        self.infoTextView.backgroundColor = ColorManager.shared.primaryDark
        
        //removed this after testing and seeing the Back button text making this look awkward
//        if let description = request?.descriptor {
//            self.title = description
//        }
        setupMap()
    }
 
    func setupInfoLabel() {
        guard let request = request else { return }
        var label = "Complaint Type: \(request.complaintType)"
        
        if let description = request.descriptor {
            label += "\nDescription: \(description)"
        }
        
        label += "\nDate: \(request.createdDate)\nStatus: \(request.status)"
        
        if let resolution = request.resolutionDescription {
            label += "\nResolution: \(resolution)\n"
        }
        
        label += "\nCommunity Board: \(request.communityBoard)"
        
        if let locType = request.locationType {
            label += "\nLocation Type: \(locType)"
        }
 
        if let incidentAddress = request.incidentAddress {
            label += "\nIncident Address: \(incidentAddress)"
        }
        
        if let crossStreet1 = request.crossStreet1,
            let crossStreet2 = request.crossStreet2 {
            label += "\nCross Streets: \(crossStreet1) & \(crossStreet2)"
        }

        
        if let bridgeHighwayName = request.bridgeHighwayName {
            label += "\nBridge/Highway: \(bridgeHighwayName)"
        }
        
        if let bridgeHighwaySegment = request.bridgeHighwaySegment {
            label += "\nSegment: \(bridgeHighwaySegment)"
        }
        
        if let bridgeHighwayDirection = request.bridgeHighwaySegment {
            label += "\nDirection: \(bridgeHighwayDirection)"
        }
        
        infoTextView.text = label
    }

    func setupMap() {
        guard let request = request,
            let coordinates = request.coordinates else { return }
        let pinAnnotation = RequestMKPointAnnotation()
        pinAnnotation.coordinate = coordinates
        pinAnnotation.title = request.descriptor
        pinAnnotation.subtitle = request.createdDate
        mapView.addAnnotation(pinAnnotation)

        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let mkCoordinateRegion = MKCoordinateRegion(center: coordinates, span: span)
        self.mapView.setRegion(mkCoordinateRegion, animated: true)
    }

}
