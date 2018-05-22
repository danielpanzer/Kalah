//
//  MoveHandler.swift
//  Kalah
//
//  Created by Daniel Panzer on 5/11/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import Foundation

class GameLogic {
    
    ///Perform a move. Returns the last a seed was placed
    static func performMove(with pit: PitIdentifier, in view: GameViewInterface, changing game: Game) -> PitIdentifier {
        
        guard let seedsToMove = game.seeds[pit] else {fatalError()}
        
        let currentPlayer: Player = {
            switch game.state {
            case .turn(let player):
                return player
            default:
                fatalError("Cannot perform a move when game is finished")
            }
        }()
        
        let availablePits = view.availablePits
        var destinationPit = pit
        
        seedsToMove.forEach { (seed) in
            
            destinationPit = PitIterator.pit(after: destinationPit, from: availablePits)
            
            if destinationPit == PitIdentifier(owner: currentPlayer.opposingPlayer, kind: .goal) {
                destinationPit = PitIterator.pit(after: destinationPit, from: availablePits)
            }
            
            game.move(seed, from: pit, to: destinationPit)
        }
        
        return destinationPit
    }
    
    static func capture(oppositeOf lastPit: PitIdentifier, in game: Game) {
        switch lastPit.kind {
        case .pit(let lastPitIndex):
            let opposingIndex = Constants.kNumberOfHouses - 1 - Int(lastPitIndex)
            let pitToCapture = PitIdentifier(owner: lastPit.owner.opposingPlayer, kind: .pit(atIndex: UInt(opposingIndex)))
            guard game.seeds[pitToCapture]?.count ?? 0 > 0 else {return}
            game.seeds[pitToCapture]?.forEach({ seed in
                game.move(seed, from: pitToCapture, to: PitIdentifier(owner: lastPit.owner, kind: .goal))
            })
            
            game.seeds[lastPit]?.forEach({ seed in
                game.move(seed, from: lastPit, to: PitIdentifier(owner: lastPit.owner, kind: .goal))
            })
        default: return
        }
        
        
    }
    
    static func winner(for game: Game) -> Player? {
        
        let playerAScore = game.seeds[PitIdentifier(owner: .playerA, kind: .goal)]!.count
        let playerBScore = game.seeds[PitIdentifier(owner: .playerB, kind: .goal)]!.count
        
        guard playerAScore != playerBScore else {return nil}
        return playerAScore > playerBScore ? .playerA : .playerB
    }
    
    static func bothPlayersHaveNonEmptyPits(in game: Game) -> Bool {
        
        let playerAPits = game.seeds.filter({$0.key.owner == .playerA && $0.key.kind != .goal})
        let playerBPits = game.seeds.filter({$0.key.owner == .playerB && $0.key.kind != .goal})
        
        let playerAHasNonEmptyPits = playerAPits.reduce(false) { (currentResult, entry) -> Bool in
            return entry.value.count > 0 ? true : currentResult
        }
        
        let playerBHasNonEmptyPits = playerBPits.reduce(false) { (currentResult, entry) -> Bool in
            return entry.value.count > 0 ? true : currentResult
        }
        
        return playerAHasNonEmptyPits && playerBHasNonEmptyPits
    }
    
    static func sweepRemainingSeedsToGoals(in game: Game) {
        
        let playerAPits = game.seeds.filter({$0.key.owner == .playerA && $0.key.kind != .goal})
        let playerBPits = game.seeds.filter({$0.key.owner == .playerB && $0.key.kind != .goal})

        playerAPits.forEach({ entry in
            entry.value.forEach({ seed in
                game.move(seed, from: entry.key, to: PitIdentifier(owner: .playerA, kind: .goal))
            })
        })
        playerBPits.forEach({ entry in
            entry.value.forEach({ seed in
                game.move(seed, from: entry.key, to: PitIdentifier(owner: .playerB, kind: .goal))
            })
        })
    }
}
