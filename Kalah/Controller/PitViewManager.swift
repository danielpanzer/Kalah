//
//  PitViewManager.swift
//  Kalah
//
//  Created by Daniel Panzer on 3/28/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import Foundation

class PitViewManager {
    
    init(with pits: [PitIdentifier : Weak<PitView>]) {
        self.pits = pits
        self.availablePits = Set(pits.keys)
    }
    
    private let pits: [PitIdentifier : Weak<PitView>]
    let availablePits: Set<PitIdentifier>
    
    func pitAfter(_ identifier: PitIdentifier) -> (view: PitView, identifier: PitIdentifier) {
        let nextPit = PitIterator.pit(after: identifier, from: availablePits)
        return (pits[nextPit]!.object!, nextPit)
    }
    
    func pit(for identifier: PitIdentifier) -> PitView? {
        return pits[identifier]?.object!
    }
    
}
