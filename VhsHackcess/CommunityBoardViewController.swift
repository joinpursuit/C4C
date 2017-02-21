//
//  CommunityBoardViewController.swift
//  VhsHackcess
//
//  Created by Sabrina Ip on 2/17/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import WebKit

class CommunityBoardViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate, WKUIDelegate, UITextViewDelegate {
    //MARK: - Outlets
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    // @IBOutlet weak var cbWebView: UIWebView!
    @IBOutlet weak var communityBoardImageView: UIImageView!
    @IBOutlet weak var linkTextView: UITextView!
    
    //MARK: - Properties
    var communityBoardCode: String = "" {
        didSet {
            let urlString = "https://www1.nyc.gov/assets/planning/images/content/pages/community/community-portal/profile/overview/\(self.communityBoardCode).gif"
            let myURL = URL(string: urlString)
            guard let url = myURL else { return }
            print(url)
            let myRequest = URLRequest(url: url)
            
            APIRequestManager.manager.getData(endPoint: urlString) { (data) in
                if let validData = data {
                    DispatchQueue.main.async {
                        self.communityBoardImageView.image = UIImage(data: validData)
                        self.communityBoardImageView.isUserInteractionEnabled = true
                    }
                }
            }
            //self.cbWebView.loadRequest(myRequest)
            Community.community.communityID = self.communityBoardCode
        }
    }
    var boardNumber: String! {
        didSet {
            Community.community.communityName = boardNumber
        }
    }
    var logoView: C4CLogoView!
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize and add View
        self.logoView = C4CLogoView(frame: CGRect(x: 0.0, y: 0.0, width: 250.0, height: 250.0))
        self.view.addSubview(self.logoView)
        self.logoView.center = self.view.center
        
        //black nav bar color and tab color
        self.navigationController?.navigationBar.barStyle = .black
        self.tabBarController?.tabBar.barStyle = .black
        self.searchButton.tintColor = ColorManager.shared.primary
        self.tabBarController?.tabBar.tintColor = ColorManager.shared.primary
        linkTextView.backgroundColor = ColorManager.shared.primary
        linkTextView.textColor = ColorManager.shared.primaryLight
        //for imageview/webview
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //rotation animation
        let animation = CABasicAnimation(keyPath: "transform.rotation.y")
        animation.duration = 3
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2.0
        animation.repeatCount = .infinity
        
        self.logoView.imageView.layer.add(animation, forKey: "transform.rotation.y")
    }
    
    func shrinkImageViewAnimation() {
        UIView.animate(withDuration: 1.5, animations: {
            self.logoView.center = self.view.center
            self.logoView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            self.logoView.alpha = 0.0
        }) { (bool) in
            self.logoView.imageView.layer.removeAllAnimations()
            self.logoView.layer.removeAllAnimations()
            self.logoView.imageView.removeFromSuperview()
            self.logoView.removeFromSuperview()
        }
    }
    
    //MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        searchButtonTapped(searchButton)
        
        return true
    }
    
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
                            
                            DispatchQueue.main.async {
                                
                                CATransaction.begin()
                                
                                CATransaction.setCompletionBlock({
                                    self.logoView.imageView.layer.removeAllAnimations()
                                    self.logoView.layer.removeAllAnimations()
                                    self.logoView.imageView.removeFromSuperview()
                                    self.logoView.removeFromSuperview()
                                })
                                
                                self.shrinkImageViewAnimation()
                                
                                CATransaction.commit()
                                
                                Community.community.borough = borough
                                self.setLink(borough: borough)
                            }
                            
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
    
    func setLink(borough: String) {
        var hyperlink = ""
        switch borough {
        case "QUEENS":
            hyperlink = "http://www.nyc.gov/html/cau/html/cb/queens.shtml"
        case "BROOKLYN":
            hyperlink = "http://www.nyc.gov/html/cau/html/cb/brooklyn.shtml"
        case "MANHATTAN":
            hyperlink = "http://www.nyc.gov/html/cau/html/cb/manhattan.shtml"
        case "STATEN ISLAND":
            hyperlink = "http://www.nyc.gov/html/cau/html/cb/si.shtml"
        case "BRONX":
            hyperlink = "http://www.nyc.gov/html/cau/html/cb/bronx.shtml"
        default: break
        }
        
        let textViewText = "Contact your community board here"
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center

        let textAttributes = [
            NSParagraphStyleAttributeName: style,
            NSForegroundColorAttributeName: ColorManager.shared.primaryLight,
            NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)
        ] as [String : Any]
        
        let linkAttributes = [
            NSLinkAttributeName: NSURL(string: hyperlink)!,
            NSForegroundColorAttributeName: ColorManager.shared.primaryDark,
        ] as [String : Any]
        
        
        let attributedString = NSMutableAttributedString(string: textViewText)
        let length = attributedString.string.characters.count
        let range = NSRange(location: 0, length: length)
        attributedString.addAttributes(textAttributes, range: range)
        attributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: hyperlink)!, range: NSMakeRange(29, 4))
//        attributedString.addAttributes(linkAttributes,range: NSMakeRange(29, 4))
        
        self.linkTextView.attributedText = attributedString
        self.linkTextView.isSelectable = true

    }
    
    func fadeTextView() {
        self.linkTextView.alpha = 0
    }
    
    func showTextView() {
        self.linkTextView.alpha = 1
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? ComplaintTypesTableViewController {
            dvc.communityBoard = self.boardNumber
        }
    }
    
}
