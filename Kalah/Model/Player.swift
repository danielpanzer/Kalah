//
//  Player.swift
//  Kalah
//
//  Created by Daniel Panzer on 4/4/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import Foundation

enum Player: Hashable {
    case playerA
    case playerB
    
    var opposingPlayer: Player {
        switch self {
        case .playerA:
            return .playerB
        case .playerB:
            return .playerA
        }
    }
}
