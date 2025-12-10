//
//  GameViewModel.swift
//  NQueens
//
//  Created by Magdalena Pamuła-Posz on 09/12/2025.
//

import Foundation
import Combine
import SwiftUI

final class GameViewModel: ObservableObject {
    @Published var game: GameEngine?
    @Published var currentBoard: [[Int]] = []
    @Published var queenPositions: [Position] = []
    
    @Published var boardSize: Int = 4
    @Published var shouldShowWinScreen = false
    
    @Published var startDate: Date?
    @Published private var now = Date()
    @Published var lastElapsed: TimeInterval?
    
    @Published var bestTimes: [Int: TimeInterval] = [:]
    @Published var shakeValue: CGFloat = 0
    
    private let bestTimesKey = "BestTimesForNQueens"
    private let feedbackProvider: FeedbackProviderProtocol
    
    let minTapSize: CGFloat = 44
    let horizontalPadding: CGFloat = 32
    
    var maxBoardSize: Int {
        let screenWidth = UIScreen.main.bounds.width
        let availableWidth = screenWidth - 2 * horizontalPadding
        let n = Int(floor(availableWidth / minTapSize))
        return max(4, n)
    }
    
    var effectiveBoardSize: Int {
        game?.boardSize ?? boardSize
    }
    
    init(feedbackProvider: FeedbackProviderProtocol = FeedbackProvider()) {
        self.feedbackProvider = feedbackProvider
        loadBestTimes()
    }
    
    func handleTap(x: Int, y: Int) {
        guard let game = game else { return }
        let position = Position(x: x, y: y)
        
        if queenPositions.contains(where: { $0 == position }) {
            let result = game.remove(at: position)
            currentBoard = result.newBoard
            queenPositions = result.occupiedPositions
            feedbackProvider.playRemove()
            return
        }
        
        guard queenPositions.count < effectiveBoardSize else { return }
        
        do {
            let result = try game.place(figure: QueenFigure(position: position))
            currentBoard = result.newBoard
            queenPositions = result.occupiedPositions
            feedbackProvider.playPlace()
            checkIfWin()
        } catch {
            withAnimation(.default) {
                shakeValue += 1
            }
            feedbackProvider.notifyError()
            feedbackProvider.playError()
        }
    }
    
    func newGame() {
        let clamped = max(4, min(boardSize, maxBoardSize))
        boardSize = clamped
        
        let newGame = GameEngine(boardSize: boardSize)
        game = newGame
        currentBoard = newGame.currentBoard
        queenPositions = []
        
        startDate = Date()
        lastElapsed = nil
    }
    
    func restart() {
        guard let game = game else { return }
        game.reset()
        currentBoard = game.currentBoard
        queenPositions = []
        
        startDate = Date()
        lastElapsed = nil
    }
    
    func checkIfWin() {
        guard queenPositions.count == effectiveBoardSize else { return }
        finishGame()
    }
    
    func finishGame() {
        guard let start = startDate else { return }
        let elapsed = Date().timeIntervalSince(start)
        lastElapsed = elapsed
        startDate = nil
        
        if let bestTime = bestTimes[effectiveBoardSize] {
            if elapsed < bestTime {
                bestTimes[effectiveBoardSize] = elapsed
            }
        } else {
            bestTimes[effectiveBoardSize] = elapsed
        }
        saveBestTimes()
        
        feedbackProvider.notifySuccess()
        feedbackProvider.playWin()
        
        shouldShowWinScreen = true
    }
    
    // MARK: Best times handling
    
    func tick(now: Date) {
        self.now = now
    }
    
    func loadBestTimes() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.data(forKey: bestTimesKey) else { return }
        if let decoded = try? JSONDecoder().decode([Int: TimeInterval].self, from: data) {
            bestTimes = decoded
        }
    }
    
    func saveBestTimes() {
        let userDefaults = UserDefaults.standard
        if let encoded = try? JSONEncoder().encode(bestTimes) {
            userDefaults.set(encoded, forKey: bestTimesKey)
        }
    }
    
    func timeString() -> String {
        if let lastElapsed {
            return format(interval: lastElapsed)
        }
        
        guard let start = startDate else { return "--:--" }
        return format(interval: now.timeIntervalSince(start))
    }
    
    func format(interval: TimeInterval) -> String {
        let total = Int(interval.rounded())
        let minutes = total / 60
        let seconds = total % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
