//
//  ChessboardView.swift
//  NQueens
//
//  Created by Magdalena Pamuła-Posz on 07/12/2025.
//

import SwiftUI

struct ChessBoardView: View {
    let moves: [[Int]]
    let queens: [Position]
    let onTap: (Int, Int) -> Void
    
    private var size: Int {
        moves.count
    }
    
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: size)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let cellSize = geometry.size.width / CGFloat(size)
            
            LazyVGrid(
                columns: columns,
                spacing: 2
            ) {
                ForEach(0..<size * size, id: \.self) { index in
                    let i = index / size
                    let j = index % size
                    
                    let isQueen = queens.contains(where: { $0.x == i && $0.y == j })
                    let isMove = moves[i][j] == 1
                    
                    ChessSquareView(row: i,
                                    column: j,
                                    isQueen: isQueen,
                                    isMove: isMove,
                                    cellSize: cellSize) {
                        onTap(i, j)
                    }
                }
            }
        }
    }
}
