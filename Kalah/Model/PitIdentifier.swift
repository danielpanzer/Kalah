//
//  PitIdentifier.swift
//  Kalah
//
//  Created by Daniel Panzer on 4/1/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import Foundation

struct PitIdentifier {
    
    let owner: Owner
    let kind: Kind
    
    enum Kind : Hashable {
        
        case pit(atIndex: UInt)
        case goal
        
        var hashValue: Int {
            switch self {
            case .goal:
                return 0
            case .pit(atIndex: let index):
                return Int(index + 1)
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
    
    enum Owner: Hashable {
        case playerA
        case playerB
        
        var hashValue: Int {
            switch self {
            case .playerA:
                return 753
            case .playerB:
                return 131
            }
        }
    }
}

extension PitIdentifier : Hashable {
    
    var hashValue: Int {
        return owner.hashValue * kind.hashValue
    }
    
    static func ==(lhs: PitIdentifier, rhs: PitIdentifier) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
