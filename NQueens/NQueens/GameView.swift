//
//  GameView.swift
//  NQueens
//
//  Created by Magdalena Pamuła-Posz on 07/12/2025.
//

import SwiftUI

struct GameView: View {
    @State private var game: GameEngineImpl?
    @State private var currentBoard: [[Int]] = []
    @State private var queenPositions: [Position] = []
    
    @State private var boardSize: Int = 4
    @State private var shouldShowWinScreen = false
    
    @State private var startDate: Date?
    @State private var now = Date()
    @State private var lastElapsed: TimeInterval?
    
    @State private var bestTimes: [Int: TimeInterval] = [:]
    
    private let timer = Timer.publish(every: 1, on : .main, in: .common).autoconnect()
    
    private let bestTimesKey = "BestTimesForNQueens"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Place \(boardSize) queens on the board. None of them can attack each other")
                        .font(.subheadline)
                    
                    HStack(spacing: 12) {
                        Text("Placed \(queenPositions.count)")
                        Text("Left \(max(0, boardSize - queenPositions.count))")
                    }
                    .font(.subheadline)
                    
                    HStack(spacing: 12) {
                        Text("Time: \(timeString())")
                        if let bestTime = bestTimes[boardSize] {
                            Text("Best: \(format(interval: bestTime))")
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if let game = game {
                    ChessBoardView(moves: currentBoard,
                                   queens: queenPositions) { x, y in
                        handleTap(x: x, y: y, game: game)
                    }
                } else {
                    Text("Tap 'New Game' to start.")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Button("New Game") {
                        newGame(size: boardSize)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Spacer()
                    
                    Button("Restart") {
                        restart()
                    }
                    .buttonStyle(.bordered)
                    .disabled(game == nil)
                }
            }
            .padding()
            .navigationTitle("N-Queens Puzzle")
            .onAppear {
                loadBestTimes()
                if game == nil {
                    newGame(size: boardSize)
                }
            }
            .onReceive(timer) { date in
                now = date
            }
            .sheet(isPresented: $shouldShowWinScreen) {
                WinScreenView(boardSize: boardSize,
                              elapsed: lastElapsed,
                              bestTime: bestTimes[boardSize]) {
                    newGame(size: boardSize)
                    shouldShowWinScreen = false
                }
            }
        }
    }
    
    private func handleTap(x: Int, y: Int, game: GameEngineImpl) {
        let position = Position(x: x, y: y)
        
        if queenPositions.contains(where: { $0 == position }) {
            let result = game.remove(at: position)
            currentBoard = result.newBoard
            queenPositions = result.occupiedPositions
            return
        }
        
        guard queenPositions.count < boardSize else { return }
        
        do {
            let result = try game.place(figure: QueenFigure(position: position))
            currentBoard = result.newBoard
            queenPositions = result.occupiedPositions
            checkIfWin()
        } catch {
            // shake
        }
    }
    
    private func newGame(size: Int) {
        let newGame = GameEngineImpl(boardSize: boardSize)
        game = newGame
        currentBoard = newGame.currentBoard
        queenPositions = []
        
        startDate = Date()
        lastElapsed = nil
    }
    
    private func restart() {
        guard let game = game else { return }
        game.reset()
        currentBoard = game.currentBoard
        queenPositions = []
        
        startDate = Date()
        lastElapsed = nil
    }
    
    private func timeString() -> String {
        if let lastElapsed {
            return format(interval: lastElapsed)
        }
        
        guard let start = startDate else { return "--:--" }
        return format(interval: now.timeIntervalSince(start))
    }
    
    private func format(interval: TimeInterval) -> String {
        let total = Int(interval.rounded())
        let minutes = total / 60
        let seconds = total % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func loadBestTimes() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.data(forKey: bestTimesKey) else { return }
        if let decoded = try? JSONDecoder().decode([Int: TimeInterval].self, from: data) {
            bestTimes = decoded
        }
    }
    
    private func saveBestTimes() {
        let userDefaults = UserDefaults.standard
        if let encoded = try? JSONEncoder().encode(bestTimes) {
            userDefaults.set(encoded, forKey: bestTimesKey)
        }
    }
    
    private func checkIfWin() {
        guard queenPositions.count == boardSize else { return }
        finishGame()
    }
    
    private func finishGame() {
        guard let start = startDate else { return }
        let elapsed = Date().timeIntervalSince(start)
        lastElapsed = elapsed
        startDate = nil
        
        if let bestTime = bestTimes[boardSize] {
            if elapsed < bestTime {
                if elapsed < bestTime {
                    bestTimes[boardSize] = elapsed
                }
            } else {
                bestTimes[boardSize] = elapsed
            }
            saveBestTimes()
            shouldShowWinScreen = true
        }
    }
}
