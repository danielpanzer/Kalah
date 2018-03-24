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
    
    override func viewDidLayoutSubviews() {
        self.gravityField.refreshGravityCenter()
    }

    //MARK: Private Properties
    
    private var gravityField: PitGravityBehavior!
    private var animator: UIDynamicAnimator!
    
    //MARK: Public Interface
    
    func activatePit(with referenceView: UIView) {
        self.animator = UIDynamicAnimator(referenceView: referenceView)
        self.gravityField = PitGravityBehavior(with: referenceView)
        self.animator.addBehavior(self.gravityField)
        //self.animator.setValue(true, forKey: "debugEnabled")
    }
    
    func add(_ seed: SeedView) {
        gravityField.add(seed)
    }

    func remove(_ seed: SeedView) {
        gravityField.remove(seed)
    }
    
}

class PitGravityBehavior : UIDynamicBehavior {
    
    //MARK: Lifecycle
    
    init(with referenceView: UIView) {
        self.referenceView = referenceView
        self.radialGravity = UIFieldBehavior.radialGravityField(position: referenceView.center)
        self.radialGravity.strength = 30
        self.radialGravity.falloff = 0.2
        
        self.itemBehavior = UIDynamicItemBehavior(items: [])
        self.itemBehavior.friction = 0
        self.itemBehavior.density = 1
        self.itemBehavior.resistance = 2
        self.itemBehavior.angularResistance = 0
        self.itemBehavior.elasticity = 0.25
        
        self.collisionBehavior = UICollisionBehavior(items: [])
        
        super.init()
        
        addChildBehavior(itemBehavior)
        addChildBehavior(radialGravity)
        addChildBehavior(collisionBehavior)
    }
    
    //MARK: Private Properties
    
    private let radialGravity: UIFieldBehavior
    private let itemBehavior: UIDynamicItemBehavior
    private let collisionBehavior: UICollisionBehavior
    weak var referenceView: UIView?
    
    //MARK: Public Interface
    
    func add(_ item: UIDynamicItem) {
        itemBehavior.addItem(item)
        radialGravity.addItem(item)
        collisionBehavior.addItem(item)
    }
    
    func remove(_ item: UIDynamicItem) {
        itemBehavior.removeItem(item)
        radialGravity.removeItem(item)
        collisionBehavior.removeItem(item)
    }
    
    func refreshGravityCenter() {
        if let view = referenceView {
            radialGravity.position = view.center
        }
    }
}
