//
//  PitIdentifier.swift
//  Kalah
//
//  Created by Daniel Panzer on 4/1/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import Foundation

struct PitIdentifier : Hashable {
    
    let owner: Player
    let kind: Kind
    
    enum Kind : Hashable {
        case pit(atIndex: UInt)
        case goal
    }
}

extension PitIdentifier : CustomStringConvertible {
    
    var description: String {
        return "Player: \(self.owner), Pit: \(self.kind)"
    }
}
