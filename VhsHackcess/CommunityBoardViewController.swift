//
//  CommunityBoardViewController.swift
//  VhsHackcess
//
//  Created by Sabrina Ip on 2/17/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import WebKit

class CommunityBoardViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate, WKUIDelegate {
    //MARK: - Outlets
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cbWebView: UIWebView!
    
    //MARK: - Properties
    var communityBoardCode: String = "" {
        didSet {
            let myURL = URL(string: "https://www1.nyc.gov/assets/planning/images/content/pages/community/community-portal/profile/overview/\(self.communityBoardCode).gif")
            guard let url = myURL else { return }
            print(url)
            let myRequest = URLRequest(url: url)
            self.cbWebView.loadRequest(myRequest)
            Community.community.communityID = self.communityBoardCode
        }
    }
    var boardNumber: String! {
        didSet {
            Community.community.communityName = boardNumber
        }
    }
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //minimize keyboard when tapping view
        setUpMinimizeKeyboardTapGesture()
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func setUpMinimizeKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    func handleTap() {
        self.addressTextField.resignFirstResponder()
    }
    
    //MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        searchButtonTapped(searchButton)
        
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
    
    //MARK: - Actions
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        print("SEARCH BUTTON TAPPED")
        
        guard let address = addressTextField.text else { return }
        
        let addressEndpoint: String = "https://api.cityofnewyork.us/geoclient/v1/search.json?app_id=aef79c41&app_key=1679304ff1bf5226d748730148f6d7f3&input=\(address)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        APIRequestManager.manager.getData(endPoint: addressEndpoint) { (data: Data?) in
            if let unwrappedData = data {
                do {
                    let jsonData: Any = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
                    guard let addressDictionary = jsonData as? [String: Any] else { return }
                    
                    if let resultsArray = addressDictionary["results"] as? [[String: Any]] {
                        
                        //throw an alert if the results have no info.
                        if resultsArray.isEmpty {
                            let alertController = UIAlertController(title: "Invalid address!",
                                                                    message: "Double-check the format before trying again.",
                                                                    preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK",
                                                         style: .default,
                                                         handler: nil)
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                        for dict in resultsArray {
                            
                            guard let response = dict["response"] as? [String: Any],
                                let borough = response["firstBoroughName"] as? String,
                                let communityBoardNumber = response["communityDistrictNumber"] as? String else { return }
                            
                            print("Borough: \(borough)")
                            print("Community Board: \(communityBoardNumber)")
                            
                            
                            switch borough {
                            case "QUEENS":
                                self.communityBoardCode = "qn" + communityBoardNumber
                                self.boardNumber = "\(communityBoardNumber) QUEENS"
                            case "BROOKLYN":
                                self.communityBoardCode = "bk" + communityBoardNumber
                                self.boardNumber = "\(communityBoardNumber) BROOKLYN"
                            case "MANHATTAN":
                                self.communityBoardCode = "mn" + communityBoardNumber
                                self.boardNumber = "\(communityBoardNumber) MANHATTAN"
                            case "STATEN ISLAND":
                                self.communityBoardCode = "si" + communityBoardNumber
                                self.boardNumber = "\(communityBoardNumber) STATEN ISLAND"
                            case "BRONX":
                                self.communityBoardCode = "bk" + communityBoardNumber
                                self.boardNumber = "\(communityBoardNumber) BRONX"
                            default:
                                self.communityBoardCode = "qn" + communityBoardNumber
                                self.boardNumber = "\(communityBoardNumber) QUEENS"
                            }
                            
                        }
                    }
                }
                catch {
                    print("Encountered an error acquiring the address.")
                }
            }
        }
        self.addressTextField.resignFirstResponder()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? ComplaintTypesTableViewController {
            dvc.communityBoard = self.boardNumber
        }
    }

}
