//
//  User.swift
//  VhsHackcess
//
//  Created by Victor Zhong on 2/18/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class User {
    var username: String
    
    init(username: String) {
        self.username = username
    }
    
    convenience init() {
        self.init(username:  "")
    }
}
