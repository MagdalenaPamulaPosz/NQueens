//
//  KnightFigure.swift
//  NQueens
//
//  Created by Magdalena Pamuła-Posz on 29/12/2025.
//

class KnightFigure: Figure {
    var position: Position
    
    init(position: Position) {
        self.position = position
    }
    
    lazy var availableMovementFields: ([[Int]]) -> [[Int]] = { [position] matrix in
        var result = matrix
        let size = matrix.count
        
        let x = position.x
        let y = position.y
        
        // All 8 possible knight moves (L-shape)
        let candidateMoves = [
            (x + 2, y + 1),
            (x + 2, y - 1),
            (x - 2, y + 1),
            (x - 2, y - 1),
            (x + 1, y + 2),
            (x + 1, y - 2),
            (x - 1, y + 2),
            (x - 1, y - 2)
        ]
        
        for (nx, ny) in candidateMoves {
            // stay inside board
            guard nx >= 0, nx < size, ny >= 0, ny < size else { continue }
            // we don't need to exclude (x, y), none of these equal the current square
            result[nx][ny] = 1
        }
        
        return result
    }
}
