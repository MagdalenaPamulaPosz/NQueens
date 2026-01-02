//
//  ChessboardView.swift
//  NQueens
//
//  Created by Magdalena Pamuła-Posz on 07/12/2025.
//

import SwiftUI

struct ChessBoardView: View {
    let moves: [[Int]]
    let figures: [Position]
    let knightsMode: Bool
    // SECOND APPROACH
//    let figureSymbol: String
    let onTap: (Int, Int) -> Void
    
    private var size: Int {
        moves.count
    }
    
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: spacing), count: size)
    }
    
    private let spacing: CGFloat = 2
    
    var body: some View {
        GeometryReader { geometry in
            let cellSize = (geometry.size.width - spacing * CGFloat(size - 1)) / CGFloat(size)
            
            LazyVGrid(
                columns: columns,
                spacing: spacing
            ) {
                ForEach(0..<size * size, id: \.self) { index in
                    let i = index / size
                    let j = index % size
                    
                    let hasFigure = figures.contains(where: { $0.x == i && $0.y == j })
                    let isMove = moves[i][j] == 1
                    
                    ChessSquareView(row: i,
                                    column: j,
                                    hasFigure: hasFigure,
                                    isMove: isMove,
                                    cellSize: cellSize,
                                    // SECOND APPROACH
                                    // figureSymbol: figureSymbol,
                                    knightsMode: knightsMode) {
                        onTap(i, j)
                    }
                }
            }
        }
    }
}
