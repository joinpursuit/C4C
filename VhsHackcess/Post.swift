//
//  Post.swift
//  VhsHackcess
//
//  Created by Victor Zhong on 2/18/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class Post {
    var uid: String
    var author: String
    var title: String
    var body: String
//    var commentCount: Int
    
    init(uid: String, author: String, title: String, body: String){ //, commentCount: Int) {
        self.uid = uid
        self.author = author
        self.title = title
        self.body = body
//        self.commentCount = commentCount
    }
    
    convenience init() {
        self.init(uid: "", author: "", title: "", body:  "")//, commentCount: 0)
    }
}
