//
//  FeedbackProvider.swift
//  NQueens
//
//  Created by Magdalena Pamuła-Posz on 09/12/2025.
//

import UIKit

protocol FeedbackProviderProtocol {
    func playPlace()
    func playRemove()
    func playError()
    func playWin()
    
    func notifySuccess()
    func notifyError()
}

final class FeedbackProvider: FeedbackProviderProtocol {
    func playPlace() {
        SoundManager.shared.playSound(fileName: "ui-click")
    }
    
    func playRemove() {
        SoundManager.shared.playSound(fileName: "whoosh-cinematic")
    }
    
    func playError() {
        SoundManager.shared.playSound(fileName: "error")
    }
    
    func playWin() {
        SoundManager.shared.playSound(fileName: "level-up")
    }
    
    func notifySuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    func notifyError() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
