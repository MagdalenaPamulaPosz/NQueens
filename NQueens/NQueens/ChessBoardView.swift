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
    
    var body: some View {
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
