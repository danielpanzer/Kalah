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
        
        let frame = self.frame.insetBy(dx: Constants.kSeedSize.width, dy: Constants.kSeedSize.height)
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
    
    func constraintsMatchingFrame(to view: UIView, withMargin margin: CGFloat) -> [NSLayoutConstraint] {
    
        let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal,
                                     toItem: view, attribute: .top, multiplier: 1, constant: margin)
        let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal,
                                     toItem: view, attribute: .bottom, multiplier: 1, constant: -margin)
        let leading = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal,
                                     toItem: view, attribute: .leading, multiplier: 1, constant: margin)
        let trailing = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal,
                                     toItem: view, attribute: .trailing, multiplier: 1, constant: -margin)
        
        return [top, bottom, leading, trailing]
        
    }
    
    func constraintsForSize(_ size: CGSize) -> [NSLayoutConstraint] {
        
        let height = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: size.height)
        let width = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: size.width)
        return [height, width]
    }
}
