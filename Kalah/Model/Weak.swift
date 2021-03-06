//
//  Weak.swift
//  Kalah
//
//  Created by Daniel Panzer on 3/25/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import Foundation

typealias SeedViewContainer = Weak<SeedView>
typealias PitViewContainer = Weak<PitView>

struct Weak<T : AnyObject & Hashable> {
    
    init(_ object: T) {
    self.object = object
    }
    weak var object: T!
}

extension Weak : Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(object)
    }
    
    static func ==(lhs: Weak<T>, rhs: Weak<T>) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
