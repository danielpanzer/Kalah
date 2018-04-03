//
//  GameController.swift
//  Kalah
//
//  Created by Daniel Panzer on 4/1/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import Foundation

class GameController {
    
    var currentPit: PitIdentifier!
    var seed: Seed!
    
    init(with viewInterface: GameViewInterface, game: Game) {
        self.viewInterface = viewInterface
        self.game = game
        
        setupGame()
        
        self.seed = Seed()
        self.currentPit = PitIdentifier(owner: .playerA, kind: .goal)
        viewInterface.add(seed: seed, to: self.currentPit)
        viewInterface.settlingMonitor.reportWhenObjectsNextSettle()
        
    }
    
    private let viewInterface: GameViewInterface
    private let game: Game
    
    private func setupGame() {
        viewInterface.availablePits.forEach { (pit) in
            if pit.kind != .goal {
                for _ in 0..<Constants.kNumberOfStartingSeeds {
                    viewInterface.add(seed: Seed(), to: pit)
                }
            }
        }
    }
    
}

extension GameController : GameViewDelegate {
    
    func controller(_ controller: GameViewController, didObserveTapAt identifier: PitIdentifier) {
        
    }
    
}

extension GameController : SeedSettlingMonitorDelegate {
    
    func seedsDidSettle() {
        let nextPit = PitIterator.pit(after: self.currentPit, from: viewInterface.availablePits)
        viewInterface.move(seed: seed, from: self.currentPit, to: nextPit)
        self.currentPit = nextPit
        self.viewInterface.settlingMonitor.reportWhenObjectsNextSettle()
        print("SETTLED")
    }
}
