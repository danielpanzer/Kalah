//
//  PitViewController.swift
//  Kalah
//
//  Created by Daniel Panzer on 3/23/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import UIKit

class PitViewController : UIViewController {
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        
        self.animator = UIDynamicAnimator(referenceView: self.view)
        self.gravityField = PitGravityBehavior(with: self.view)
        self.animator.addBehavior(self.gravityField)
    }

    //MARK: Private Properties
    
    private var gravityField: PitGravityBehavior!
    private var animator: UIDynamicAnimator!
    
    //MARK: Public Interface
    
    func add(_ item: UIDynamicItem) {
        gravityField.add(item)
    }

    func remove(_ item: UIDynamicItem) {
        gravityField.remove(item)
    }
    
}

class PitGravityBehavior : UIDynamicBehavior {
    
    //MARK: Lifecycle
    
    init(with referenceView: UIView) {
        self.radialGravity = UIFieldBehavior.radialGravityField(position: referenceView.center)
        self.radialGravity.strength = 100
        
        self.itemBehavior = UIDynamicItemBehavior(items: [])
        
        super.init()
        
        addChildBehavior(itemBehavior)
        addChildBehavior(radialGravity)
    }
    
    //MARK: Private Properties
    
    private let radialGravity: UIFieldBehavior
    private let itemBehavior: UIDynamicItemBehavior
    
    //MARK: Public Interface
    
    func add(_ item: UIDynamicItem) {
        itemBehavior.addItem(item)
    }
    
    func remove(_ item: UIDynamicItem) {
        itemBehavior.removeItem(item)
    }
}
