//
//  PitView.swift
//  Kalah
//
//  Created by Daniel Panzer on 3/23/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import UIKit

class PitView : UIView {
    
    //MARK: Private Properties
    
    private var gravityField: PitGravityBehavior!
    
    //MARK: Public Interface
    
    func activatePit(with animator: UIDynamicAnimator, center: CGPoint) {
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.cornerRadius = (frame.width)/2
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        
        self.gravityField = PitGravityBehavior(with: center)
        animator.addBehavior(self.gravityField)
    }
    
    func add(_ seed: SeedView) {
        gravityField.add(seed)
    }

    func remove(_ seed: SeedView) {
        gravityField.remove(seed)
    }
    
}
