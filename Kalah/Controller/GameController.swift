//
//  GameController.swift
//  Kalah
//
//  Created by Daniel Panzer on 4/1/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import Foundation

protocol GameViewInterface {
    func add(seed: Seed, to location: PitIdentifier)
    func move(seed: Seed, from fromLocation: PitIdentifier, to toLocation: PitIdentifier)
    
    var availablePits: Set<PitIdentifier> {get}
    var settlingMonitor: SeedSettlingMonitor {get}
}

class GameController {
    
    init(with viewInterface: GameViewInterface, game: Game) {
        self.viewInterface = viewInterface
        self.game = game
        
        setupGame()
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
        
    }
}
