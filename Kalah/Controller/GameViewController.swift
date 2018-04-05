//
//  GameViewController.swift
//  Kalah
//
//  Created by Daniel Panzer on 3/23/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import UIKit

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
    
    private var seedViews = Set<SeedViewContainer>()
    private var pitViews: [PitIdentifier : PitViewContainer]!
    private var _availablePits: Set<PitIdentifier>!
    private var _settlingMonitor: SeedSettlingMonitor!
    private var motionHandler: SeedMotionHandler!
    
    weak var delegate: GameViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup animator and boundary
        self.animator = UIDynamicAnimator(referenceView: view)
        self.boundary = UICollisionBehavior(items: [])
        self.boundary.addBoundary(withIdentifier: NSString(string: "frame"), for: UIBezierPath(rect: view.frame))
        self.animator.addBehavior(self.boundary)
        
        var pitViews = [PitIdentifier : PitViewContainer]()
        
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
        
        goalA.activatePit(with: animator, center: goalContainerA.center, tapTarget: nil)
        goalB.activatePit(with: animator, center: goalContainerB.center, tapTarget: nil)

        pitViews[PitIdentifier(owner: .playerA, kind: .goal)] = PitViewContainer(goalA)
        pitViews[PitIdentifier(owner: .playerB, kind: .goal)] = PitViewContainer(goalB)
        
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
                    entry.value.object.activatePit(with: self.animator, center: pitCenter, tapTarget: self)
                case .playerB:
                    let pitCenter = self.bHousesContainer.convert(entry.value.object.center, to: self.view)
                    entry.value.object.activatePit(with: self.animator, center: pitCenter, tapTarget: self)
                }
            }
        }
        
        self.pitViews = pitViews
        self._availablePits = Set(pitViews.keys)
        self._settlingMonitor = SeedSettlingMonitor(with: pitViews.values.map({$0}), delegate: nil)
        self._settlingMonitor.startMonitoring()
        self._settlingMonitor.reportWhenSeedsNextSettle()
        
        self.motionHandler = SeedMotionHandler(with: pitViews.values.map({$0}))
        
        //self.animator.setValue(true, forKey: "debugEnabled")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController : PitViewTapResponder {
    
    func pitViewWasTapped(with gestureRecognizer: UITapGestureRecognizer) {
        let view = gestureRecognizer.view as! PitView
        let identifier = pitViews.first { entry -> Bool in entry.value.object === view}!.key
        delegate?.controller(self, didObserveTapAt: identifier)
    }
}

extension GameViewController : GameViewInterface {
    
    func add(seed: Seed, to location: PitIdentifier) {
        
        let pit = pitViews[location]!.object!
        let newSeedView = SeedView.seed(with: seed.id, color: .randomSelectedColor)
        newSeedView.center = self.view.randomPositionOnPerimeter
        self.view.addSubview(newSeedView)
        pit.add(newSeedView)
        self.boundary.addItem(newSeedView)
        seedViews.insert(Weak(newSeedView))
        
    }
    
    func move(seed: Seed, from fromLocation: PitIdentifier, to toLocation: PitIdentifier) {
        
        let view = seedViews.first(where: {$0.object.uuid == seed.id})!.object!
        let fromPit = pitViews[fromLocation]!.object!
        let toPit = pitViews[toLocation]!.object!
        fromPit.remove(view)
        toPit.add(view)
        
    }
    
    var availablePits: Set<PitIdentifier> {
        return _availablePits
    }
    
    var settlingMonitor: SeedSettlingMonitor {
        return self._settlingMonitor
    }
}
