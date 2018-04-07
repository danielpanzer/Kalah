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
    
    static var randomSelectedColor: UIColor {
        let index = Int(arc4random_uniform(UInt32(colorPossibilities.count)))
        return colorPossibilities[index]
    }
    
    private static var colorPossibilities: [UIColor] {
        return [
            UIColor(red: 0.85, green: 0.1, blue: 0.1, alpha: 1),
            UIColor(red: 0.341176470588235, green: 0.807843137254902, blue: 0.137254901960784, alpha: 1),
            UIColor.orange,
            UIColor(red: 0.258823529411765, green: 0.525490196078431, blue: 0.956862745098039, alpha: 1),
            UIColor(red: 0.654901960784314, green: 0.258823529411765, blue: 0.956862745098039, alpha: 1),
            UIColor.yellow,
            UIColor.magenta,
            UIColor.cyan
        ]
        
    }
    
}
