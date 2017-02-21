//
//  WebViewController.swift
//  VhsHackcess
//
//  Created by Sabrina Ip on 2/19/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!

    var endpointString: String = "http://www.nyc.gov/html/cau/html/cb/cb.shtml"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let boro = Community.community.borough {
            switch boro {
            case "QUEENS":
                self.endpointString = "http://www.nyc.gov/html/cau/html/cb/queens.shtml"
            case "BROOKLYN":
                self.endpointString = "http://www.nyc.gov/html/cau/html/cb/brooklyn.shtml"
            case "MANHATTAN":
                self.endpointString = "http://www.nyc.gov/html/cau/html/cb/manhattan.shtml"
            case "STATEN ISLAND":
                self.endpointString = "http://www.nyc.gov/html/cau/html/cb/si.shtml"
            case "BRONX":
                self.endpointString = "http://www.nyc.gov/html/cau/html/cb/bronx.shtml"
            default: break
            }
        }
        
        let myURL = URL(string: endpointString)
        guard let url = myURL else { return }
        let myRequest = URLRequest(url: url)
        self.webView.loadRequest(myRequest)
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    @IBAction func reloadButtonPressed(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    @IBAction func forwardButtonPressed(_ sender: UIBarButtonItem) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
}
