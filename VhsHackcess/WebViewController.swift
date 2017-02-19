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
    var borough: String?
    
//    var communityBoardCode: String = "" {
//        didSet {
//            let urlString = "https://www1.nyc.gov/assets/planning/images/content/pages/community/community-portal/profile/overview/\(self.communityBoardCode).gif"
//            let myURL = URL(string: urlString)
//            guard let url = myURL else { return }
//            print(url)
//            let myRequest = URLRequest(url: url)
//            
//            APIRequestManager.manager.getData(endPoint: urlString) { (data) in
//                if let validData = data {
//                    DispatchQueue.main.async {
//                        self.communityBoardImageView.image = UIImage(data: validData)
//                        self.communityBoardImageView.isUserInteractionEnabled = true
//                    }
//                }
//            }
//            //self.cbWebView.loadRequest(myRequest)
//            Community.community.communityID = self.communityBoardCode
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
