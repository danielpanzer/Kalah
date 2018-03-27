//
//  GameViewController.swift
//  Kalah
//
//  Created by Daniel Panzer on 3/23/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet private weak var goalContainerA: UIView!
    @IBOutlet private weak var goalContainerB: UIView!
    
    private weak var goalPitA: PitView!
    private weak var goalPitB: PitView!
    
    @IBOutlet private weak var aHousesContainer: UIStackView!
    @IBOutlet private weak var bHousesContainer: UIStackView!
    
    private var aHouses = [Weak<PitView>]()
    private var bHouses = [Weak<PitView>]()
    
    private var animator: UIDynamicAnimator!
    private var boundary: UICollisionBehavior!
    
    override func viewDidLoad() {
        
        //Setup animator and boundary
        self.animator = UIDynamicAnimator(referenceView: view)
        self.boundary = UICollisionBehavior(items: [])
        self.boundary.addBoundary(withIdentifier: NSString(string: "frame"), for: UIBezierPath(rect: view.frame))
        self.animator.addBehavior(self.boundary)
        
        //Set up goals
        let goalA = PitView(frame: .zero)
        let goalB = PitView(frame: .zero)
        goalA.translatesAutoresizingMaskIntoConstraints = false
        goalB.translatesAutoresizingMaskIntoConstraints = false

        let goalAConstraints = goalA.constraintsMatchingFrame(to: goalContainerA, withMargin: 10)
        let goalBConstraints = goalB.constraintsMatchingFrame(to: goalContainerB, withMargin: 10)

        goalContainerA.addSubview(goalA)
        goalContainerB.addSubview(goalB)
        view.addConstraints(goalAConstraints + goalBConstraints)

        view.layoutIfNeeded()
        
        goalA.activatePit(with: animator, center: goalContainerA.center)
        goalB.activatePit(with: animator, center: goalContainerB.center)

        self.goalPitA = goalA
        self.goalPitB = goalB
        
        //Set up houses
        
        for _ in 0..<Constants.kNumberOfHouses {
            
            let aHouse = PitView(frame: .zero)
            self.aHousesContainer.addArrangedSubview(aHouse)
            self.aHousesContainer.addConstraints(aHouse.constraintsForSize(Constants.kHouseSize))
            self.aHouses.append(Weak(value: aHouse))
        
            let bHouse = PitView(frame: .zero)
            self.bHousesContainer.addArrangedSubview(bHouse)
            self.bHousesContainer.addConstraints(bHouse.constraintsForSize(Constants.kHouseSize))
            self.bHouses.append(Weak(value: bHouse))
        }
        
        view.layoutIfNeeded()
        
        aHouses.forEach { (pit) in
            let pitCenter = self.aHousesContainer.convert(pit.value.center, to: self.view)
            pit.value.activatePit(with: self.animator, center: pitCenter)
            for _ in 0...3 {self.addNewSeed(to: pit.value)}
        }
        
        bHouses.forEach { (pit) in
            let pitCenter = self.bHousesContainer.convert(pit.value.center, to: self.view)
            pit.value.activatePit(with: self.animator, center: pitCenter)
            for _ in 0...3 {self.addNewSeed(to: pit.value)}
        }
        

        //self.animator.setValue(true, forKey: "debugEnabled")
    }
    
    private func addNewSeed(to pit: PitView) {
        let seed = SeedView.seed(with: .randomColor)
        seed.center = self.view.randomPositionOnPerimeter
        self.view.addSubview(seed)
        pit.add(seed)
        self.boundary.addItem(seed)
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
