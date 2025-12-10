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
    let isQueen: Bool
    let isMove: Bool
    let cellSize: CGFloat
    let onTap: () -> Void
    
    var body: some View {
        let backgroundColor: Color = {
            if isMove {
                return .red.opacity(0.45)
            } else if (row + column).isMultiple(of: 2) {
                return .gray.opacity(0.3)
            } else {
                return .gray.opacity(0.1)
            }
        }()
        
        ZStack {
            Rectangle()
                .fill(backgroundColor)
            
            Text("♛")
                .font(.system(size: cellSize * 0.7))
                .scaleEffect(isQueen ? 1.0 : 0.5)
                .opacity(isQueen ? 1 : 0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6),
                           value: isQueen)
        }
        .aspectRatio(1, contentMode: .fit)
        .onTapGesture {
            onTap()
        }
    }
}
