//
//  CommunityBoardViewController.swift
//  VhsHackcess
//
//  Created by Sabrina Ip on 2/17/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class CommunityBoardViewController: UIViewController {

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var infoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func getDataTapped(_ sender: UIButton) {
    }
    
    // MARK: - TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    

}
