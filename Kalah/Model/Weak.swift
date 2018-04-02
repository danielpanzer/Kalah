//
//  Weak.swift
//  Kalah
//
//  Created by Daniel Panzer on 3/25/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import Foundation

struct Weak<T : AnyObject> {
    
    init(_ object: T) {
    self.object = object
    }
    weak var object: T!
}
