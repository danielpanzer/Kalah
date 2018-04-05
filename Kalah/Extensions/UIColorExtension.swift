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
        let index = Int(arc4random_uniform(UInt32(colorPossibilities.count) - 1))
        return colorPossibilities[index]
    }
    
    private static var colorPossibilities: [UIColor] {
        return [
            UIColor.red,
            UIColor.green,
            UIColor.orange,
            UIColor.white,
            UIColor.purple,
            UIColor.yellow,
            UIColor.magenta,
            UIColor.cyan
        ]
        
    }
    
}
