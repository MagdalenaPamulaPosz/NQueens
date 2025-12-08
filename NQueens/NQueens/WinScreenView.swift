//
//  WinScreenView.swift
//  NQueens
//
//  Created by Magdalena Pamuła-Posz on 08/12/2025.
//

import SwiftUI

struct WinScreenView: View {
    let boardSize: Int
    let elapsed: TimeInterval?
    let bestTime: TimeInterval?
    
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
            }
            .onAppear {
                animate = true
            }
        }
    }
}
