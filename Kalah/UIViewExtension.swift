//
//  UIViewExtension.swift
//  Kalah
//
//  Created by Daniel Panzer on 3/24/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import UIKit

extension UIView {
    
    var randomPositionOnPerimeter: CGPoint {
        
        let edge = CGRectEdge(rawValue: arc4random_uniform(3))!
        
        switch edge {
            
        case .minXEdge:
            let y = arc4random_uniform(UInt32(frame.height))
            return CGPoint(x: 0, y: CGFloat(y))
        case .minYEdge:
            let x = arc4random_uniform(UInt32(frame.width))
            return CGPoint(x: CGFloat(x), y: 0)
        case .maxXEdge:
            let y = arc4random_uniform(UInt32(frame.height))
            return CGPoint(x: frame.width, y: CGFloat(y))
        case .maxYEdge:
            let x = arc4random_uniform(UInt32(frame.width))
            return CGPoint(x: CGFloat(x), y: frame.height)
        }
        
    }
}
