//
//  Styles.swift
//  Forecast
//
//  Created by Evan Brass on 6/3/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import UIKit

enum FontSize: Int {
    case yuge = 120
    case title = 28
    case large = 18
    case medium = 14
    case small = 10
    
    var cgFloatValue: CGFloat {
        return CGFloat(self.rawValue)
    }
}

extension UIFont {
    static func thin(_ size: FontSize = .large) -> UIFont {
        UIFont(name: "PingFangSC-Thin", size: size.cgFloatValue)!
    }
    static func light(_ size: FontSize = .large) -> UIFont {
        UIFont(name: "PingFangSC-Light", size: size.cgFloatValue)!
    }
}

let cellMargin: CGFloat = 16
let cellMargins = UIEdgeInsets(top: 0, left: cellMargin, bottom: 0, right: cellMargin)
