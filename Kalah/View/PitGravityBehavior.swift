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
        self.itemBehavior.density = 1
        self.itemBehavior.resistance = 2
        self.itemBehavior.angularResistance = 0
        self.itemBehavior.elasticity = 0.25
        
        self.collisionBehavior = UICollisionBehavior(items: [])
        
        super.init()
        
        self.collisionBehavior.collisionDelegate = self
        
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

extension PitGravityBehavior : UICollisionBehaviorDelegate {
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        let item1Velocity = itemBehavior.linearVelocity(for: item1)
        let item2Velocity = itemBehavior.linearVelocity(for: item2)
        let averageVelocity = CGPoint(x: (abs(item1Velocity.x) + abs(item2Velocity.x))/2, y: (abs(item1Velocity.y) + abs(item2Velocity.y))/2)
        let averageForce = (averageVelocity.x + averageVelocity.y)/2
        guard averageForce > 300 else {return}
        let volume = max(averageForce/1000, 0.8)
        SoundManager.shared.playTap(withVolume: Float(volume))
    }
}
