//
//  Game.swift
//  Kalah
//
//  Created by Daniel Panzer on 4/1/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import Foundation

protocol GameDelegate: class {
    func game(_ game: Game, didChangeStateTo state: Game.State)
    func game(_ game: Game, didAddSeed seed: Seed, to pit: PitIdentifier)
    func game(_ game: Game, didRemoveSeed seed: Seed, from pit: PitIdentifier)
    func game(_ game: Game, didMoveSeed seed: Seed, from fromPit: PitIdentifier, to toPit: PitIdentifier)
}

class Game {
    
    init(with delegate: GameDelegate?) {
        self.delegate = delegate
    }
    
    enum State : Equatable {
        case turn(Player)
        case completed
        
        var currentPlayer: Player? {
            switch self {
            case .turn(let currentPlayer): return currentPlayer
            default: return nil
            }
        }
        
        static func ==(lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case let (.turn(player1), .turn(player2)): return player1 == player2
            case (.completed, .completed): return true
            default: return false
            }
        }
    }
    
    //MARK: Public Interface
    
    weak var delegate: GameDelegate?
    
    var state: State {
        get {
            return _state
        }
        set {
            guard newValue != _state else {return}
            _state = newValue
            delegate?.game(self, didChangeStateTo: newValue)
        }
    }
    
    var seeds: [PitIdentifier : Set<Seed>] {
        return _seeds
    }
    
    func add(_ seed: Seed, to pit: PitIdentifier) {
        if add(seed, to: pit) {
            delegate?.game(self, didAddSeed: seed, to: pit)
        }
    }
    
    func remove(_ seed: Seed, from pit: PitIdentifier) {
        if remove(seed, from: pit) {
            delegate?.game(self, didRemoveSeed: seed, from: pit)
        }
    }
    
    func move(_ seed: Seed, from fromPit: PitIdentifier, to toPit: PitIdentifier) {
        if remove(seed, from: fromPit), add(seed, to: toPit) {
            delegate?.game(self, didMoveSeed: seed, from: fromPit, to: toPit)
        }
    }
    
    //MARK: Private Properties
    
    private var _state: State = .turn(.playerA)
    private var _seeds = [PitIdentifier : Set<Seed>]()
    
    //MARK: Private Methods
    
    private func add(_ seed: Seed, to pit: PitIdentifier) -> Bool {
        guard _seeds[pit] == nil || !_seeds[pit]!.contains(seed) else {
            assertionFailure("add called for pit that already contains seed")
            return false
        }
        
        if let result = _seeds[pit]?.insert(seed) {
            assert(result.inserted, "should never fail insertion since we've guaranteed the set does not contain the seed")
        } else {
            _seeds[pit] = Set(arrayLiteral: seed)
        }
        return true
    }
    
    private func remove(_ seed: Seed, from pit: PitIdentifier) -> Bool {
        guard _seeds[pit] != nil && _seeds[pit]!.contains(seed) else {
            assertionFailure("remove called for pit that does not contain seed")
            return false
        }
        
        if let _ = _seeds[pit]?.remove(seed) {
            return true
        } else {
            assertionFailure()
            return false
        }
    }
}
