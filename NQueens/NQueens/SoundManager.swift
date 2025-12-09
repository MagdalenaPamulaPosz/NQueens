//
//  SoundManager.swift
//  NQueens
//
//  Created by Magdalena Pamuła-Posz on 09/12/2025.
//

import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var player: AVAudioPlayer?
    
    func playSound(fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
