//
//  Constants.swift
//  Kalah
//
//  Created by Daniel Panzer on 3/23/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import UIKit

struct Constants {
    static let kSeedSize = CGSize(width: 25, height: 25)
    static let kHouseSize = CGSize(width: 100, height: 100)
    static let kNumberOfHouses = 6
    
    static let kUserAccelerationSensitivity: Double = 50
    static let kRotationRateSensitivity: Double = 10
    static let kDeviceMotionUpdateInterval: TimeInterval = 1.0/60
    
    static let kSettlingMonitorRefreshRate: TimeInterval = 0.25
    static let kSettlingMonitorSensitivity: CGFloat = 100
}
