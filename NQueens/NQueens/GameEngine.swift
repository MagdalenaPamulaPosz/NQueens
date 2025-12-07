//
//  GameEngine.swift
//  NQueens
//
//  Created by Magdalena Pamuła-Posz on 05/12/2025.
//

enum PlacementError: Error {
    case occupied, outsideBounds, invalid
}

struct PlacementResult {
    let newBoard: [[Int]]
    let occupiedPositions: [Position]
}

protocol GameEngine {
    init(boardSize: Int)
    
    var currentBoard: [[Int]] { get }
    
    func place(figure: Figure) throws(PlacementError) -> PlacementResult
}

struct Position: Equatable {
    let x: Int
    let y: Int
}

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
        
        let x = Int(position.x)
        let y = Int(position.y)
        
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

class GameEngineImpl: GameEngine {
    var figures: [Figure] = []
    var boardMatrix: [[Int]]
    var currentBoard: [[Int]] { boardMatrix }
    
    required init(boardSize: Int) {
        boardMatrix = Array(repeating: Array(repeating: 0, count: Int(boardSize)), count: Int(boardSize))
    }
    
    func place(figure: Figure) throws(PlacementError) -> PlacementResult {
        let size = boardMatrix.count
        guard figure.position.x < size, figure.position.y < size else {
            throw .outsideBounds
        }
        guard !figures.contains(where: { $0.position == figure.position }) else {
            throw .occupied
        }
        let possibleMoves = figure.availableMovementFields(boardMatrix)
        for figure in figures {
            if possibleMoves[Int(figure.position.x)][Int(figure.position.y)] == 1 {
                throw .invalid
            }
        }
        figures.append(figure)
        boardMatrix = boardMatrix.merge(with: possibleMoves)
        return .init(newBoard: boardMatrix, occupiedPositions: figures.map { $0.position })
    }
}

extension Array where Element == [Int] {
    func merge(with other: [[Int]]) -> [[Int]] {
        zip(self, other).map { rowA, rowB in
            zip(rowA, rowB).map { Swift.max($0, $1) }
        }
    }
}
