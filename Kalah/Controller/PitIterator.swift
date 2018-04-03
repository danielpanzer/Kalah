//
//  PitIterator.swift
//  Kalah
//
//  Created by Daniel Panzer on 4/1/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import Foundation

class PitIterator {
    
    private static func isValidPitArrangement(with pits: Set<PitIdentifier>) -> Bool {
        
        let requiredContents = Set([
            PitIdentifier(owner: .playerA, kind: .goal),
            PitIdentifier(owner: .playerB, kind: .goal),
            PitIdentifier(owner: .playerA, kind: .pit(atIndex: 0)),
            PitIdentifier(owner: .playerB, kind: .pit(atIndex: 0))
            ])
        
        return pits.isSuperset(of: requiredContents)
        
    }
    
    static func pit(after pit: PitIdentifier, from availablePits: Set<PitIdentifier>) -> PitIdentifier {
        
        precondition(isValidPitArrangement(with: availablePits), "Iterator was passed an invalid game arrangement")
        
        switch pit.kind {
        case .goal:
            let newOwner = pit.owner.opposingPlayer
            let index = availablePits.reduce(UInt(), { (nextPartialResult, element) -> UInt in
                guard element.owner == newOwner else {return nextPartialResult}
                switch element.kind {
                case .goal: return nextPartialResult
                case .pit(atIndex: let index): return max(index, nextPartialResult)
                }
            })
                
            return PitIdentifier(owner: newOwner, kind: .pit(atIndex: index))
            
        case .pit(atIndex: let index):
            if index > 0 {
                return PitIdentifier(owner: pit.owner, kind: .pit(atIndex: index-1))
            } else {
                return PitIdentifier(owner: pit.owner, kind: .goal)
            }
        }
    }
    
}
