//
//  ColorManager.swift
//  VhsHackcess
//
//  Created by Harichandan Singh on 2/19/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation
import UIKit

class ColorManager {
    //MARK: - Properties
    static let shared = ColorManager()
    
    let _50: UIColor = UIColor(hexString: "#F1F8E9")
    let _100: UIColor = UIColor(hexString: "#DCEDC8")
    let _200: UIColor = UIColor(hexString: "#C5E1A5")
    let _300: UIColor = UIColor(hexString: "#AED581")
    let _400: UIColor = UIColor(hexString: "#9CCC65")
    let _500: UIColor = UIColor(hexString: "#8BC34A")
    let _600: UIColor = UIColor(hexString: "#7CB342")
    let _700: UIColor = UIColor(hexString: "#689F38")
    let _800: UIColor = UIColor(hexString: "#558B2F")
    let _900: UIColor = UIColor(hexString: "#33691E")
    
    var colorArray: [UIColor] {
//        return [_300, _400, _500, _600, _700, _800, _900, _800, _700, _600, _500, _400, _300, _200]
        return [_900, _800, _700, _600, _500, _400, _300, _400, _500, _600, _700, _800, _900, _800]
    }
    var primary: UIColor {
        return _500
    }
    var primaryDark: UIColor {
        return _700
    }
    var primaryLight: UIColor {
        return _100
    }
//    var accent: UIColor {
//        return a200
//    }
    
    //MARK: - Initializer
    private init() {}
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
