//
//  ContentView.swift
//  NQueens
//
//  Created by Magdalena Pamuła-Posz on 05/12/2025.
//

import SwiftUI

struct SquareView: View {
    @State private var currentBoard: [[Int]]?
    @State private var queenPositions: [Position]?
    @State private var game: GameEngine?
    @State private var boardSizeInput: String = ""
    
    var body: some View {
        VStack {
            if let game, let queenPositions {
                ChessBoardView(moves: game.currentBoard, queens: queenPositions) { x, y in
                    guard let placementResult = try? game.place(figure: QueenFigure(position: .init(x: Int(x), y: Int(y)))) else {
                        print("you cannot do it")
                        return
                    }
                    currentBoard = placementResult.newBoard
                    self.queenPositions = placementResult.occupiedPositions
                }
                Button("Reset") {
                    self.game = nil
                    boardSizeInput = ""
                    self.queenPositions = nil
                }
                .padding()
                .buttonStyle(.bordered)
            } else {
                Text("Enter board size")
                    .font(.title3)
                TextField("8", text: $boardSizeInput)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                Button("Create Board") {
                    if let size = Int(boardSizeInput) {
                        game = GameEngineImpl(boardSize: size)
                        queenPositions = []
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}

//#Preview {
//    SquareView()
//}
