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

protocol GameEngineProtocol {
    init(boardSize: Int)
    
    var currentBoard: [[Int]] { get }
    var boardSize: Int { get }
    var occupiedPosistions: [Position] { get }
    
    func place(figure: Figure) throws -> PlacementResult
    func remove(at position: Position) -> PlacementResult
    func reset()
}

struct Position: Equatable {
    let x: Int
    let y: Int
}

class GameEngine: GameEngineProtocol {
    var figures: [Figure] = []
    var boardMatrix: [[Int]]
    
    var currentBoard: [[Int]] {
        boardMatrix
    }
    
    var boardSize: Int {
        boardMatrix.count
    }
    
    var occupiedPosistions: [Position] {
        figures.map { $0.position }
    }
    
    required init(boardSize: Int) {
        boardMatrix = Array(repeating: Array(repeating: 0,
                                             count: boardSize),
                            count: boardSize)
    }
    
    func place(figure: Figure) throws -> PlacementResult {
        let size = boardMatrix.count
        
        guard figure.position.x < size, figure.position.y < size else {
            throw PlacementError.outsideBounds
        }
        
        guard !figures.contains(where: { $0.position == figure.position }) else {
            throw PlacementError.occupied
        }
        
        let possibleMoves = figure.availableMovementFields(boardMatrix)
        
        for figure in figures {
            if possibleMoves[figure.position.x][figure.position.y] == 1 {
                throw PlacementError.invalid
            }
        }
        
        figures.append(figure)
        boardMatrix = boardMatrix.merge(with: possibleMoves)
        
        return PlacementResult(newBoard: boardMatrix, occupiedPositions: occupiedPosistions)
    }
    
    func reset() {
        figures.removeAll()
        boardMatrix = Array(repeating: Array(repeating: 0,
                                             count: boardSize),
                            count: boardSize)
    }
    
    func remove(at position: Position) -> PlacementResult {
        if let index = figures.firstIndex(where: { $0.position == position }) {
            figures.remove(at: index)
        }
        
        boardMatrix = Array(repeating: Array(repeating: 0,
                                             count: boardSize),
                            count: boardSize)
        
        for figure in figures {
            let moves = figure.availableMovementFields(boardMatrix)
            boardMatrix = boardMatrix.merge(with: moves)
        }
        
        return PlacementResult(newBoard: boardMatrix, occupiedPositions: occupiedPosistions)
    }
}

extension Array where Element == [Int] {
    func merge(with other: [[Int]]) -> [[Int]] {
        zip(self, other).map { rowA, rowB in
            zip(rowA, rowB).map { Swift.max($0, $1) }
        }
    }
}
