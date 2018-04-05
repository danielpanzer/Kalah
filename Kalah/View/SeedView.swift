//
//  SeedView.swift
//  Kalah
//
//  Created by Daniel Panzer on 3/23/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import UIKit

class SeedView : UIView {
    
    var uuid: UUID {
        return _uuid
    }
    
    private var _uuid: UUID!
    
    static func seed(with uuid: UUID, color: UIColor) -> SeedView {
        let seed = SeedView(frame: CGRect(origin: .zero, size: Constants.kSeedSize))
        seed._uuid = uuid
        seed.translatesAutoresizingMaskIntoConstraints = false
        seed.isUserInteractionEnabled = false
        seed.backgroundColor = color
        seed.layer.cornerRadius = Constants.kSeedSize.width/2
        seed.layer.borderColor = UIColor.black.cgColor
        seed.layer.borderWidth = 1
        
        return seed
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
    
    override var hashValue: Int {
        return _uuid.hashValue
    }
    
}
