//
//  Seed.swift
//  Kalah
//
//  Created by Daniel Panzer on 3/23/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import UIKit

class SeedView : UIView {
    
    static func seed(with color: UIColor) -> SeedView {
        let size = CGSize(width: Constants.kSeedSize, height: Constants.kSeedSize)
        let seed = SeedView(frame: CGRect(origin: .zero, size: size))
        seed.backgroundColor = color
        seed.layer.cornerRadius = CGFloat(Constants.kSeedSize)/2
        return seed
    }
    
}
