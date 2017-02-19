//
//  IndividualComplaintViewController.swift
//  VhsHackcess
//
//  Created by Sabrina Ip on 2/17/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class IndividualComplaintViewController: UIViewController {

    @IBOutlet weak var infoTextView: UITextView!
    var request: ServiceRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInfoLabel()
    }
 
    func setupInfoLabel() {
        guard let request = request else { return }
        var label = "Complaint Type: \(request.complaintType)"
        
        if let description = request.descriptor {
            label += "\nDescription: \(description)"
        }
        
        label += "\nDate: \(request.createdDate)\nStatus: \(request.status)"
        
        if let resolution = request.resolutionDescription {
            label += "\nResolution: \(resolution)"
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

 

}
