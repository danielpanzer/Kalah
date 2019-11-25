//
//  PitIdentifier.swift
//  Kalah
//
//  Created by Daniel Panzer on 4/1/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import Foundation

struct PitIdentifier {
    
    let owner: Player
    let kind: Kind
    
    enum Kind : Hashable {
        
        case pit(atIndex: UInt)
        case goal
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .pit(let atIndex):
                hasher.combine(atIndex)
            case .goal:
                break
            }
        }
        
        var indexValue: Int {
            switch self {
            case .goal:
                return -1
            case .pit(atIndex: let index):
                return Int(index)
            }
        }
        
        static func ==(lhs: Kind, rhs: Kind) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
    }
}

extension PitIdentifier : Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(owner)
        hasher.combine(kind)
    }
    
    static func ==(lhs: PitIdentifier, rhs: PitIdentifier) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension PitIdentifier : CustomStringConvertible {
    
    var description: String {
        return "Player: \(self.owner), Pit: \(self.kind)"
    }
}
