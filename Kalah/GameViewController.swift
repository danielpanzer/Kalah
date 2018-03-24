//
//  GameViewController.swift
//  Kalah
//
//  Created by Daniel Panzer on 3/23/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var pitVC: PitViewController!
    
    override func viewDidLoad() {
        add()
    }
    
    private func add() {
        let time = DispatchTime.now() + DispatchTimeInterval.seconds(1)
        DispatchQueue.main.asyncAfter(deadline: time) {
            let seed = SeedView.seed(with: UIColor.randomColor)
            seed.center = self.view.randomPositionOnPerimeter
            self.view.addSubview(seed)
            self.pitVC.add(seed)
            self.add()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PitViewControllerEmbed" {
            self.pitVC = segue.destination as! PitViewController
            self.pitVC.activatePit(with: self.view)
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
