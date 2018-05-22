//
//  FIFOQueue.swift
//  Kalah
//
//  Created by Daniel Panzer on 5/21/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import Foundation

class FIFOQueue<T> {
    
    init(with content: [T]) {
        self.content = content
    }
    
    init() {
        self.content = []
    }
    
    private var content: [T]
    
    
    func push(_ value: T) {
        content.append(value)
    }
    
    func pop() -> T? {
        guard content.count > 0 else {return nil}
        return content.removeFirst()
    }
}
