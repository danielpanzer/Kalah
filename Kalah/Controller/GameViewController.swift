//
//  GameViewController.swift
//  Kalah
//
//  Created by Daniel Panzer on 6/9/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import UIKit

protocol BoardViewInterface: class {
    func add(_ seed: Seed, to location: PitIdentifier)
    func move(_ seed: Seed, from fromLocation: PitIdentifier, to toLocation: PitIdentifier)
    
    var gameLabelText: String? {get set}
    func rotateGameLabel(to player: Player)
    
    func highlightPits(for player: Player?)
    
    var availablePits: Set<PitIdentifier> {get}
    var settlingMonitor: SeedSettlingMonitor {get}
    
    var shouldAllowUserInteraction: Bool {get set}
}

class GameViewController : UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BoardViewControllerEmbed" {
            let boardViewController = segue.destination as! BoardViewController
            boardViewController.delegate = self
            board = boardViewController
        }
    }
    
    override func viewDidLoad() {
        board.settlingMonitor.delegate = self
        
        board.availablePits.forEach { (pit) in
            guard pit.kind != .goal else {return}
            for _ in 0..<4 {board.add(Seed(), to: pit)}
        }
    }
    
    var board: BoardViewInterface!
    
    
    
    
}

extension GameViewController : BoardViewDelegate {
    
    func controller(_ controller: BoardViewController, didObserveTapAt identifier: PitIdentifier) {
        
    }
}

extension GameViewController : SeedSettlingMonitorDelegate {
    
    func seedsDidSettle() {
        
    }
}

