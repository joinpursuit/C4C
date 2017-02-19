//
//  UserProfileViewController.swift
//  VhsHackcess
//
//  Created by Victor Zhong on 2/19/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLoggedIn()
        if let user = FIRAuth.auth()?.currentUser {
            statusLabel.text = user.displayName
        }
    }
    
    func checkLoggedIn() {
        if FIRAuth.auth()?.currentUser == nil {
            // push profile Instantly
            performSegue(withIdentifier: "notLoggedIn", sender: self)
        }
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
