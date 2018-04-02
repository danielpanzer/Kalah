//
//  UIColorExtension.swift
//  Kalah
//
//  Created by Daniel Panzer on 3/23/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var randomColor: UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(255))/255,
                       green: CGFloat(arc4random_uniform(255))/255,
                       blue: CGFloat(arc4random_uniform(255))/255,
                       alpha: 1)
    }
    
}
