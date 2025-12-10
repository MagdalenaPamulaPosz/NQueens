//
//  QueenFogure.swift
//  NQueens
//
//  Created by Magdalena Pamuła-Posz on 07/12/2025.
//

protocol Figure {
    var position: Position { get }
    var availableMovementFields: ([[Int]]) -> [[Int]] { get }
}

class QueenFigure: Figure {
    var position: Position
    
    init(position: Position) {
        self.position = position
    }
    
    lazy var availableMovementFields: ([[Int]]) -> [[Int]] = { [position] matrix in
        var result = matrix
        let size = matrix.count
        
        let x = position.x
        let y = position.y
        
        // Horizontal and Vertical
        for i in 0..<size {
            if i != y { result[x][i] = 1 }
            if i != x { result[i][y] = 1 }
        }
        
        // Diagonals
        for i in 0..<size {
            for j in 0..<size {
                if abs(i - x) == abs(j - y) && !(i == x && j == y) {
                    result[i][j] = 1
                }
            }
        }
        
        return result
    }
}
