//
//  WinScreenView.swift
//  NQueens
//
//  Created by Magdalena Pamuła-Posz on 08/12/2025.
//

import SwiftUI

struct WinScreenView: View {
    let elapsed: TimeInterval?
    let bestTime: TimeInterval?
    let onPlayAgain: () -> Void
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("You win! 🎉")
                    .font(.largeTitle)
                    .scaleEffect(animate ? 1.2 : 0.8)
                    .animation(
                        .easeInOut(duration: 0.5)
                        .repeatForever(autoreverses: true),
                        value: animate
                    )
                
                if let elapsed = elapsed {
                    Text("Time: \(String(format: "%.2f", elapsed)) seconds")
                        .font(.headline)
                }
                
                if let bestTime = bestTime {
                    Text("Best time: \(String(format: "%.2f", bestTime)) seconds")
                        .font(.headline)
                }
                
                Button {
                    onPlayAgain()
                } label: {
                    Text("Play again :)")
                        .font(.headline)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.top, 20)
            }
            .onAppear {
                animate = true
            }
        }
    }
}
