//
//  SeedMotionHandler.swift
//  Kalah
//
//  Created by Daniel Panzer on 4/4/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import UIKit
import CoreMotion

class SeedMotionHandler {
    
    init(with views: [PitViewContainer]) {
        self.views = views
        
        self.queue = OperationQueue()
        self.queue.qualityOfService = .background
        
        self.manager = CMMotionManager()
        self.manager.deviceMotionUpdateInterval = 1.0/60
        self.manager.startDeviceMotionUpdates(to: self.queue, withHandler: handle(data:error:))
    }
    
    private let views: [PitViewContainer]
    private let manager: CMMotionManager
    private let queue: OperationQueue
    
    private func handle(data: CMDeviceMotion?, error: Error?) {
        guard let motion = data else {return}
        let velocity = CGPoint(x: motion.userAcceleration.y*50 + motion.rotationRate.x*10,
                               y: motion.userAcceleration.x*50 + motion.rotationRate.y*10)
        DispatchQueue.main.async {
            self.views.map({$0.object!}).forEach { (view) in
                view.addLinearVelocity(with: velocity)
            }
        }
    }
    
}
