//
//  ChessSquareView.swift
//  NQueens
//
//  Created by Magdalena Pamuła-Posz on 07/12/2025.
//

import SwiftUI

struct ChessSquareView: View {
    let row: Int
    let column: Int
    let hasFigure: Bool
    let isMove: Bool
    let cellSize: CGFloat
    let figureSymbol: String
    let onTap: () -> Void
    
    private var backgroundColor: Color {
        if isMove {
            return .red.opacity(0.45)
        } else if (row + column).isMultiple(of: 2) {
            return .gray.opacity(0.3)
        } else {
            return .gray.opacity(0.1)
        }
    }
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(backgroundColor)
            
            Text(figureSymbol)
                .font(.system(size: cellSize * 0.7))
                .scaleEffect(hasFigure ? 1.0 : 0.5)
                .opacity(hasFigure ? 1 : 0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6),
                           value: hasFigure)
        }
        .frame(width: cellSize, height: cellSize)
        .onTapGesture {
            onTap()
        }
    }
}
