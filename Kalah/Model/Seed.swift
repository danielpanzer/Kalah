//
//  Seed.swift
//  Kalah
//
//  Created by Daniel Panzer on 3/26/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import Foundation

struct Seed {
    
    init() {}
    let id: UUID = UUID()
}

extension Seed : Equatable {
    
    static func ==(lhs: Seed, rhs: Seed) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Seed : Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
