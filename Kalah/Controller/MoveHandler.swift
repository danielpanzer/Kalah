//
//  MoveHandler.swift
//  Kalah
//
//  Created by Daniel Panzer on 5/11/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import Foundation

class MoveHandler {
    
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
}
