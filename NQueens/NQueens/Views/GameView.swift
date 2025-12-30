//
//  GameView.swift
//  NQueens
//
//  Created by Magdalena Pamuła-Posz on 07/12/2025.
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    private let timer = Timer.publish(every: 1, on : .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                sizeControl
                statusSection
                boardView
                Spacer()                
                bottomButtons
            }
            .padding()
            .navigationTitle("N-Queens Puzzle")
            .onReceive(timer) { date in
                viewModel.tick(now: date)
            }
            .sheet(isPresented: $viewModel.shouldShowWinScreen) {
                WinScreenView(elapsed: viewModel.lastElapsed,
                              bestTime: viewModel.bestTimes[viewModel.effectiveBoardSize]) {
                    viewModel.newGame()
                    viewModel.shouldShowWinScreen = false
                }
            }
        }
    }
    
    private var sizeControl: some View {
        HStack {
            Text("Board size: \(viewModel.boardSize)")
                .font(.headline)
            Spacer()
            Stepper(
                "",
                value: $viewModel.boardSize,
                in: 4...viewModel.maxBoardSize
            )
        }
    }
    
    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Place \(viewModel.effectiveBoardSize) figures on the board. None of them can attack each other")
                .font(.subheadline)
            
            HStack(spacing: 12) {
                Text("Placed \(viewModel.figurePositions.count)")
                Text("Left \(max(0, viewModel.effectiveBoardSize - viewModel.figurePositions.count))")
            }
            .font(.subheadline)
            
            HStack(spacing: 12) {
                Text("Time: \(viewModel.timeString())")
                if let bestTime = viewModel.bestTimes[viewModel.effectiveBoardSize] {
                    Text("Best: \(viewModel.format(interval: bestTime))")
                }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            
            Picker("Figure type", selection: $viewModel.figureType) {
                ForEach(FigureType.allCases) { type in
                    Text(type.displayName).tag(type)
                }
            }
            .pickerStyle(.segmented)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var bottomButtons: some View {
        HStack {
            Button("New Game") {
                viewModel.newGame()
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
            
            Button("Restart") {
                viewModel.restart()
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.game == nil)
        }
    }
    
    private var boardView: some View {
        Group {
            if viewModel.game != nil {
                ChessBoardView(
                    moves: viewModel.currentBoard,
                    figures: viewModel.figurePositions,
                    figureSymbol: viewModel.figureType.symbol) { x, y in
                    viewModel.handleTap(x: x, y: y)
                }
                .modifier(ShakeEffect(animatableData: viewModel.shakeValue))
            } else {
                Text("Choose a board size and tap \"New Game\" to start.")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
    }
    
}
