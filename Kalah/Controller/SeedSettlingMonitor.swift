//
//  SeedSettlingMonitor.swift
//  Kalah
//
//  Created by Daniel Panzer on 4/2/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import UIKit

protocol SeedSettlingMonitorDelegate: class {
    func seedsDidSettle()
}

class SeedSettlingMonitor {
    
    //MARK: Lifecycle
    
    init(with reporters: [PitViewContainer], delegate: SeedSettlingMonitorDelegate?) {
        self.reporters = reporters
        self.delegate = delegate
    }
    
    //MARK: Private Properties
    
    private let reporters: [PitViewContainer]
    private var timer: Timer?
    private var shouldReportWhenObjectsHaveSettled = false
    
    //MARK: Public Interface
    
    weak var delegate: SeedSettlingMonitorDelegate?
    
    func startMonitoring() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [unowned self] (timer) in
            if self.shouldReportWhenObjectsHaveSettled && self.objectsHaveSettled {
                self.delegate?.seedsDidSettle()
                self.shouldReportWhenObjectsHaveSettled = false
            }
        })
    }
    
    func stopMonitoring() {
        timer?.invalidate()
    }
    
    func reportWhenObjectsNextSettle() {
        let time = DispatchTime.now() + DispatchTimeInterval.seconds(1)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.shouldReportWhenObjectsHaveSettled = true
        }
    }
    
    var objectsHaveSettled: Bool {
        let velocities = reporters.reduce([CGPoint]()) { (nextPartialResult, element) -> [CGPoint] in
            return nextPartialResult + element.object.currentVelocities
        }
        
        return velocities.reduce(true, { (nextPartialResult, element) -> Bool in
            return abs(element.x) > 50 || abs(element.y) > 50 ? false : nextPartialResult
        })
    }
    
    
    
}
