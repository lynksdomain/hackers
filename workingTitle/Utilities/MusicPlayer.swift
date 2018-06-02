//
//  MusicPlayer.swift
//  workingTitle
//
//  Created by C4Q on 5/10/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import AVFoundation

class MusicHelper {
    private var player: AVAudioPlayer?
    private init() {}
    static let manager = MusicHelper()
    
    func playMusic() {
        guard let path = Bundle.main.url(forResource: "theme", withExtension: ".mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: path, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            
            player.numberOfLoops = -1
            player.prepareToPlay()
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playMainMenuTheme() {
        guard let path = Bundle.main.url(forResource: "mainMenuTheme", withExtension: ".mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: path, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            
            player.numberOfLoops = -1
            player.prepareToPlay()
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    func stopMusic() {
        guard let player = player else { return }
        player.stop()
    }
}
