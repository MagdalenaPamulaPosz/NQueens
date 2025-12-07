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
    
    @State private var boardSize: Int = 8
    @State private var shouldShowWinScreen = false
    
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
                if game == nil {
                    newGame(size: boardSize)
                }
            }
        }
    }
    
    private func handleTap(x: Int, y: Int, game: GameEngineImpl) {
        
    }
    
    private func newGame(size: Int) {
        
    }
    
    private func restart() {
        
    }
}
