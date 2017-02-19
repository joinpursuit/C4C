//
//  C4CLogoView.swift
//  VhsHackcess
//
//  Created by Harichandan Singh on 2/19/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class C4CLogoView: UIView {
    var imageView: UIImageView!
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createView()
    }
    
    func createView() {
        self.backgroundColor = UIColor.clear
        
        imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "C4C.png")
        
        self.addSubview(imageView)
    }
    
}
