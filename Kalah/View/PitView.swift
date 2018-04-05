//
//  PitView.swift
//  Kalah
//
//  Created by Daniel Panzer on 3/23/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import UIKit
import CoreMotion

@objc protocol PitViewTapResponder {
    func pitViewWasTapped(with gestureRecognizer: UITapGestureRecognizer)
}

class PitView : UIView {
    
    //MARK: Private Properties
    
    private var gravityField: PitGravityBehavior!
    
    //MARK: Public Interface
    
    func activatePit(with animator: UIDynamicAnimator, center: CGPoint, tapTarget: PitViewTapResponder?) {
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.cornerRadius = (frame.width)/2
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        
        self.gravityField = PitGravityBehavior(with: center)
        animator.addBehavior(self.gravityField)
        
        if let target = tapTarget {
            let tapRecognizer = UITapGestureRecognizer(target: target, action: #selector(target.pitViewWasTapped(with:)))
            addGestureRecognizer(tapRecognizer)
        }
    }
    
    func add(_ seed: SeedView) {
        gravityField.add(seed)
    }

    func remove(_ seed: SeedView) {
        gravityField.remove(seed)
    }
    
    func addLinearVelocity(with velocity: CGPoint) {
        gravityField.addLinearVelocity(with: velocity)
    }
    
    var currentVelocities: [CGPoint] {
        return gravityField.currentVelocities
    }
    
}
