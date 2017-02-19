//
//  RequestMKPointAnnotation.swift
//  VhsHackcess
//
//  Created by Sabrina Ip on 2/18/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import MapKit

class RequestMKPointAnnotation: MKPointAnnotation {
//    var request: ServiceRequest?
    var index: Int = 0

    convenience init(index: Int, request: ServiceRequest) {
        self.init()
        self.index = index
//        self.request = request
    }
}
