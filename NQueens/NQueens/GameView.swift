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
    @State private var shakeValue: CGFloat = 0
    
    private let timer = Timer.publish(every: 1, on : .main, in: .common).autoconnect()
    
    private let bestTimesKey = "BestTimesForNQueens"
    
    private let minTapSize: CGFloat = 44
    private let horizontalPadding: CGFloat = 32
    
    private var maxBoardSize: Int {
        let screenWidth = UIScreen.main.bounds.width
        let availableWidth = screenWidth - 2 * horizontalPadding
        let n = Int(floor(availableWidth / minTapSize))
        return max(4, n)
    }
    
    private var effectiveBoardSize: Int {
        game?.boardSize ?? boardSize
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                HStack {
                    Text("Board size: \(effectiveBoardSize) x \(effectiveBoardSize)")
                        .font(.headline)
                    Spacer()
                    Stepper(
                        "",
                        value: $boardSize,
                        in: 4...maxBoardSize
                    )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Place \(boardSize) queens on the board. None of them can attack each other")
                        .font(.subheadline)
                    
                    HStack(spacing: 12) {
                        Text("Placed \(queenPositions.count)")
                        Text("Left \(max(0, effectiveBoardSize - queenPositions.count))")
                    }
                    .font(.subheadline)
                    
                    HStack(spacing: 12) {
                        Text("Time: \(timeString())")
                        if let bestTime = bestTimes[effectiveBoardSize] {
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
                    }.modifier(ShakeEffect(animatableData: shakeValue))
                } else {
                    VStack {
                        Text("Choose a board size and tap 'New Game' to start.")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            }
            .onReceive(timer) { date in
                now = date
            }
            .sheet(isPresented: $shouldShowWinScreen) {
                WinScreenView(boardSize: effectiveBoardSize,
                              elapsed: lastElapsed,
                              bestTime: bestTimes[effectiveBoardSize]) {
                    newGame(size: effectiveBoardSize)
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
            SoundManager.shared.playSound(fileName: "whoosh-cinematic")
            return
        }
        
        guard queenPositions.count < effectiveBoardSize else { return }
        
        do {
            let result = try game.place(figure: QueenFigure(position: position))
            currentBoard = result.newBoard
            queenPositions = result.occupiedPositions
            SoundManager.shared.playSound(fileName: "ui-click")
            checkIfWin()
        } catch {
            withAnimation(.default) {
                shakeValue += 1
            }
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
            SoundManager.shared.playSound(fileName: "error")
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
        guard queenPositions.count == effectiveBoardSize else { return }
        finishGame()
    }
    
    private func finishGame() {
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
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        SoundManager.shared.playSound(fileName: "level-up")
        
        shouldShowWinScreen = true
    }
}
