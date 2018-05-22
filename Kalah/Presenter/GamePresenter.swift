//
//  GameController.swift
//  Kalah
//
//  Created by Daniel Panzer on 4/1/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import Foundation

protocol GameViewInterface: class {
    func add(_ seed: Seed, to location: PitIdentifier)
    func move(_ seed: Seed, from fromLocation: PitIdentifier, to toLocation: PitIdentifier)
    func set(gameStateTo gameState: Game.State)
    
    var availablePits: Set<PitIdentifier> {get}
    var settlingMonitor: SeedSettlingMonitor {get}
    
    var shouldAllowUserInteraction: Bool {get set}
}

class GamePresenter {
    
    init(with view: GameViewInterface, game: Game) {
        self.view = view
        self.game = game
    }
    
    private let view: GameViewInterface
    private let game: Game
    
    private var workToRunOnSettle = FIFOQueue<() -> ()>()
    
    func setupGame() {
        view.availablePits.forEach { (pit) in
            if pit.kind != .goal {
                for _ in 0..<Constants.kNumberOfStartingSeeds {
                    game.add(Seed(), to: pit)
                }
            }
        }
        view.set(gameStateTo: .turn(.playerA))
    }
}

extension GamePresenter : GameViewDelegate {
    
    func controller(_ controller: GameViewController, didObserveTapAt identifier: PitIdentifier) {
        guard identifier.owner == game.state.currentPlayer else {return}
        
        let lastPit = MoveHandler.performMove(with: identifier, in: self.view, changing: self.game)
        view.settlingMonitor.reportWhenSeedsNextSettle()
        view.shouldAllowUserInteraction = false
        
        workToRunOnSettle.push {
            self.view.shouldAllowUserInteraction = true
            guard lastPit != PitIdentifier(owner: self.game.state.currentPlayer!, kind: .goal) else {return}
            self.game.state = .turn(self.game.state.currentPlayer!.opposingPlayer)
        }
    }
}

extension GamePresenter : SeedSettlingMonitorDelegate {
    
    func seedsDidSettle() {
        assert(Thread.isMainThread)
        while let work = workToRunOnSettle.pop() {
            work()
        }
    }
}

extension GamePresenter : GameDelegate {
    
    func game(_ game: Game, didChangeStateTo state: Game.State) {
         view.set(gameStateTo: state)
    }
    
    func game(_ game: Game, didAddSeed seed: Seed, to pit: PitIdentifier) {
        view.add(seed, to: pit)
    }
    
    func game(_ game: Game, didMoveSeed seed: Seed, from fromPit: PitIdentifier, to toPit: PitIdentifier) {
        view.move(seed, from: fromPit, to: toPit)
    }
    
    func game(_ game: Game, didRemoveSeed seed: Seed, from pit: PitIdentifier) {/* Intentionally does nothing */}
    
}
