//
//  SoundManager.swift
//  Kalah
//
//  Created by Daniel Panzer on 4/4/18.
//  Copyright © 2018 Daniel Panzer. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    private init() {
        let resource = Bundle.main.url(forResource: "Marble Tap", withExtension: "mov")!
        self.tapSoundEffect = AVAsset(url: resource)
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.players = self.players.filter({$0.rate > 0})
        }
    }
    
    static let shared = SoundManager()
    
    private var players = Set<AVPlayer>()
    private let tapSoundEffect: AVAsset
    
    func playTap(withVolume volume: Float) {
        DispatchQueue.global(qos: .userInitiated).async {
            let playerItem = AVPlayerItem(asset: self.tapSoundEffect)
            let player = AVPlayer(playerItem: playerItem)
            player.volume = volume
            self.players.insert(player)
            player.play()
        }
    }
}
