//
//  Comment.swift
//  VhsHackcess
//
//  Created by Victor Zhong on 2/18/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class Comment {
    var uid: String
    var author: String
    var text: String
    
    init(uid: String, author: String, text: String) {
        self.uid = uid
        self.author = author
        self.text = text
    }
    
    convenience init() {
        self.init(uid: "", author: "", text: "")
    }
}

