//
//  PitGravityBehavior.swift
//  Kalah
//
//  Created by Daniel Panzer on 3/25/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import UIKit

class PitGravityBehavior : UIDynamicBehavior {
    
    //MARK: Lifecycle
    
    init(with center: CGPoint) {
        self.radialGravity = UIFieldBehavior.radialGravityField(position: center)
        self.radialGravity.strength = 30
        self.radialGravity.falloff = 0.2
        
        self.itemBehavior = UIDynamicItemBehavior(items: [])
        self.itemBehavior.friction = 0
        self.itemBehavior.density = 10
        self.itemBehavior.resistance = 5
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
    
    func addLinearVelocity(with velocity: CGPoint) {
        itemBehavior.items.forEach({itemBehavior.addLinearVelocity(velocity, for: $0)})
    }
    
    var currentVelocities: [CGPoint] {
        return itemBehavior.items.map({itemBehavior.linearVelocity(for: $0)})
    }
    
}
