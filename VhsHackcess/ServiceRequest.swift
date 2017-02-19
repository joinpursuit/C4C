//
//  ServiceRequest.swift
//  VhsHackcess
//
//  Created by Harichandan Singh on 2/18/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation
import MapKit

enum ParsingErrors: Error {
    case communityBoardError, complaintTypeError, createdDateError, descriptorError, statusError, uniqueKeyError
}

class ServiceRequest {
    //MARK: - Properties
    let bridgeHighwayDirection: String?
    let bridgeHighwayName: String?
    let bridgeHighwaySegment: String?
    let communityBoard: String
    let complaintType: String
    let createdDate: String
    let crossStreet1: String?
    let crossStreet2: String?
    let descriptor: String?
    let incidentAddress: String?
    let coordinates: CLLocationCoordinate2D?
    let locationType: String?
    let resolutionDescription: String?
    let status: String
    let uniqueKey: String
    
    //MARK: - Initializer
    init(bridgeHighwayDirection: String?, bridgeHighwayName: String?, bridgeHighwaySegment: String?, communityBoard: String, complaintType: String, createdDate: String, crossStreet1: String?, crossStreet2: String?, descriptor: String?, incidentAddress: String?, coordinates: CLLocationCoordinate2D?, locationType: String?, resolutionDescription: String?, status: String, uniqueKey: String) {
        
        self.bridgeHighwayDirection = bridgeHighwayDirection
        self.bridgeHighwayName = bridgeHighwayName
        self.bridgeHighwaySegment = bridgeHighwaySegment
        self.communityBoard = communityBoard
        self.complaintType =  complaintType
        self.createdDate = createdDate
        self.crossStreet1 = crossStreet1
        self.crossStreet2 = crossStreet2
        self.descriptor = descriptor
        self.incidentAddress = incidentAddress
        self.coordinates = coordinates
        self.locationType = locationType
        self.resolutionDescription = resolutionDescription
        self.status = status
        self.uniqueKey = uniqueKey
    }
    
    //MARK: - Methods
    static func getServiceRequests(data: Data) -> [ServiceRequest]? {
        
        var serviceRequests: [ServiceRequest]? = []
        
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let arrayOfServiceRequests = jsonData as? [[String: Any]] else { return nil }
            
            print("Number of objects in dictionary: \(arrayOfServiceRequests.count)")
            
            for dict in arrayOfServiceRequests {
                
                var bhd: String?
                if let bridgeHighwayDirection = dict["bridge_highway_direction"] as? String {
                    bhd = bridgeHighwayDirection
                }
                
                var bhn: String?
                if let bridgeHighwayName = dict["bridge_highway_name"] as? String {
                    bhn = bridgeHighwayName
                }
                
                var bhs: String?
                if let bridgeHighwaySegment = dict["bridge_highway_segment"] as? String {
                    bhs = bridgeHighwaySegment
                }
                
                var cs1: String?
                if let crossStreet1 = dict["cross_street_1"] as? String {
                    cs1 = crossStreet1
                }

                var cs2: String?
                if let crossStreet2 = dict["cross_street_2"] as? String {
                    cs2 = crossStreet2
                }
                
                var incidentAddress: String?
                if let incidentAdd = dict["incident_address"] as? String {
                    incidentAddress = incidentAdd
                }
                
                let location = dict["location"] as? [String: Any]
                
                var descriptor: String?
                if let des = dict["descriptor"] as? String {
                    descriptor = des
                }
                
                var coordinates: CLLocationCoordinate2D?
                if let coord = location?["coordinates"] as? [Double],
                    let longitude = coord[0] as? Double,
                    let latitude = coord[1] as? Double {
                    coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                }
                
                var locationType: String?
                if let locType = dict["location_type"] as? String {
                    locationType = locType
                }
                
                var resolutionDescription: String?
                if let resDes = dict["resolution_description"] as? String {
                    resolutionDescription = resDes
                }
                
                guard let communityBoard = dict["community_board"] as? String else { throw ParsingErrors.communityBoardError }
                
                guard let complaintType = dict["complaint_type"] as? String else { throw ParsingErrors.complaintTypeError }
                
                guard let createdDate = dict["created_date"] as? String else { throw ParsingErrors.createdDateError }
                
                guard let status = dict["status"] as? String else { throw ParsingErrors.statusError }
                
                guard let uniqueKey = dict["unique_key"] as? String else { throw ParsingErrors.uniqueKeyError }
                
                let serviceRequest: ServiceRequest = ServiceRequest(bridgeHighwayDirection: bhd,
                                                                    bridgeHighwayName: bhn,
                                                                    bridgeHighwaySegment: bhs,
                                                                    communityBoard: communityBoard,
                                                                    complaintType: complaintType,
                                                                    createdDate: createdDate,
                                                                    crossStreet1: cs1,
                                                                    crossStreet2: cs2,
                                                                    descriptor: descriptor,
                                                                    incidentAddress: incidentAddress,
                                                                    coordinates: coordinates,
                                                                    locationType: locationType,
                                                                    resolutionDescription: resolutionDescription,
                                                                    status: status,
                                                                    uniqueKey: uniqueKey)
                
                serviceRequests?.append(serviceRequest)
            }
//            print("Array count: \(serviceRequests?.count)")
//            dump(serviceRequests)
            
        }
        catch ParsingErrors.communityBoardError {
            print("Error parsing community board.")
        }
        catch ParsingErrors.complaintTypeError {
            print("Error parsing complaint type.")
        }
        catch ParsingErrors.createdDateError {
            print("Error parsing created date.")
        }
        catch ParsingErrors.descriptorError {
            print("Error parsing descriptor")
        }
        catch ParsingErrors.statusError {
            print("Error parsing status")
        }
        catch ParsingErrors.uniqueKeyError {
            print("Error parsing unique keys")
        }
        catch {
            print("Unidentified parsing error")
        }
        return serviceRequests
    }
    
}

