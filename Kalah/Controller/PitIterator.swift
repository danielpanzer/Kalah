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
            
            return availablePits.reduce(pit, { (nextPartialResult, element) -> PitIdentifier in
                
                guard element.owner != pit.owner else {
                    return nextPartialResult
                }
                
                switch element.kind {
                case .goal:
                    return nextPartialResult
                case .pit(atIndex: let index):
                    return Int(index) > nextPartialResult.kind.indexValue ? element : nextPartialResult
                }
            })
            
        case .pit(atIndex: let index):
            
            let nextPit = PitIdentifier(owner: pit.owner, kind: .pit(atIndex: index+1))
            if availablePits.contains(nextPit) {
                return nextPit
            } else {
                switch pit.owner {
                case .playerA:
                    return PitIdentifier(owner: .playerB, kind: .goal)
                case .playerB:
                    return PitIdentifier(owner: .playerA, kind: .goal)
                }
            }
        }
    }
    
}
