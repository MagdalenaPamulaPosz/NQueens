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

struct ChessBoardView: View {
    let moves: [[Int]]
    let queens: [Position]
    let onTap: (Int, Int) -> Void
    
    var body: some View {
        VStack {
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: moves.count),
                spacing: 2
            ) {
                ForEach(0..<moves.count * moves.count, id: \.self) { index in
                    let i = index / moves.count
                    let j = index % moves.count
                    
                    let isQueen = queens.contains(where: { $0.x == i && $0.y == j })
                    let isMove = moves[i][j] == 1
                    
                    ZStack {
                        
                        Rectangle()
                            .fill(isMove ? Color.green.opacity(0.45) :
                               (i + j).isMultiple(of: 2)
                               ? Color.gray.opacity(0.3)
                               : Color.gray.opacity(0.1))
                        
                        if isQueen {
                            Text("♛")
                                .font(.system(size: 24))
                        }
                        
                    }
                    .aspectRatio(1, contentMode: .fit)
                    .onTapGesture {
                        onTap(i, j)
                    }
                }
            }
        }
    }
}

//#Preview {
//    SquareView()
//}
