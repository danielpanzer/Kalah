//
//  GameViewController.swift
//  Kalah
//
//  Created by Daniel Panzer on 3/23/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import UIKit

protocol GameViewInterface {
    func add(seed: Seed, to location: PitIdentifier)
    func move(seed: Seed, from fromLocation: PitIdentifier, to toLocation: PitIdentifier)
    
    var availablePits: Set<PitIdentifier> {get}
}

protocol GameViewDelegate: class {
    func controller(_ controller: GameViewController, didObserveTapAt identifier: PitIdentifier)
}

class GameViewController: UIViewController {

    @IBOutlet private weak var goalContainerA: UIView!
    @IBOutlet private weak var goalContainerB: UIView!
    
    @IBOutlet private weak var aHousesContainer: UIStackView!
    @IBOutlet private weak var bHousesContainer: UIStackView!
    
    private var animator: UIDynamicAnimator!
    private var boundary: UICollisionBehavior!
    
    private var pitManager: PitViewManager!
    private var seedViews = [Weak<SeedView>]()
    
    weak var delegate: GameViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup animator and boundary
        self.animator = UIDynamicAnimator(referenceView: view)
        self.boundary = UICollisionBehavior(items: [])
        self.boundary.addBoundary(withIdentifier: NSString(string: "frame"), for: UIBezierPath(rect: view.frame))
        self.animator.addBehavior(self.boundary)
        
        var pitViews = [PitIdentifier : Weak<PitView>]()
        
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

        pitViews[PitIdentifier(owner: .playerA, kind: .goal)] = Weak(goalA)
        pitViews[PitIdentifier(owner: .playerB, kind: .goal)] = Weak(goalB)
        
        //Set up houses
        
        for index in 0..<Constants.kNumberOfHouses {
            
            let aHouse = PitView(frame: .zero)
            self.aHousesContainer.addArrangedSubview(aHouse)
            self.aHousesContainer.addConstraints(aHouse.constraintsForSize(Constants.kHouseSize))
        
            let bHouse = PitView(frame: .zero)
            self.bHousesContainer.addArrangedSubview(bHouse)
            self.bHousesContainer.addConstraints(bHouse.constraintsForSize(Constants.kHouseSize))
            
            assert(Constants.kNumberOfHouses - 1 - index >= 0)
            pitViews[PitIdentifier(owner: .playerA, kind: .pit(atIndex: UInt(Constants.kNumberOfHouses - 1 - index)))] = Weak(aHouse)
            pitViews[PitIdentifier(owner: .playerB, kind: .pit(atIndex: UInt(index)))] = Weak(bHouse)
        }
        
        view.layoutIfNeeded()
        
        pitViews.forEach { (entry) in
            
            switch entry.key.kind {
            case .goal:
                return
            case .pit(atIndex: _):
                switch entry.key.owner {
                case .playerA:
                    let pitCenter = self.aHousesContainer.convert(entry.value.object.center, to: self.view)
                    entry.value.object.activatePit(with: self.animator, center: pitCenter)
                case .playerB:
                    let pitCenter = self.bHousesContainer.convert(entry.value.object.center, to: self.view)
                    entry.value.object.activatePit(with: self.animator, center: pitCenter)
                }
            }
        }
        
        self.pitManager = PitViewManager(with: pitViews)
        
        //self.animator.setValue(true, forKey: "debugEnabled")
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

extension GameViewController : GameViewInterface {
    
    func add(seed: Seed, to location: PitIdentifier) {
        
        let pit = pitManager.pit(for: location)!
        let newSeedView = SeedView.seed(with: seed.id, color: .randomColor)
        newSeedView.center = self.view.randomPositionOnPerimeter
        self.view.addSubview(newSeedView)
        pit.add(newSeedView)
        self.boundary.addItem(newSeedView)
        seedViews.append(Weak(newSeedView))
        
    }
    
    func move(seed: Seed, from fromLocation: PitIdentifier, to toLocation: PitIdentifier) {
        
    }
    
    var availablePits: Set<PitIdentifier> {
        return pitManager.availablePits
    }
    
}
