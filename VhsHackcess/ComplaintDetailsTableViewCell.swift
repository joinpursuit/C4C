//
//  ComplaintDetailsTableViewCell.swift
//  VhsHackcess
//
//  Created by Sabrina Ip on 2/17/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class ComplaintDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptorLabel: UILabel!
    @IBOutlet weak var timeAndDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Actions
    
    @IBAction func infoButtonPressed(_ sender: UIButton) {
    }
}
