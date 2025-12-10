//
//  NQueensTests.swift
//  NQueensTests
//
//  Created by Magdalena Pamuła-Posz on 05/12/2025.
//

import XCTest
@testable import NQueens

final class GameEngineTests: XCTestCase {

    func testInitialBoardIsEmpty() {
        let engine = GameEngine(boardSize: 4)
        XCTAssertEqual(engine.currentBoard.count, 4)
        XCTAssertTrue(engine.occupiedPosistions.isEmpty)
        
        for row in engine.currentBoard {
            XCTAssertTrue(row.allSatisfy { $0 == 0 })
        }
    }
    
    func testPlaceFirstQueenMarksAttackedSquares() throws {
        let engine = GameEngine(boardSize: 4)
        
        let result = try engine.place(figure: QueenFigure(position: Position(x: 1, y: 1)))
        
        XCTAssertEqual(result.occupiedPositions.count, 1)
        XCTAssertEqual(result.occupiedPositions.first, Position(x: 1, y: 1))
        
        let board = result.newBoard
        
        for i in 0..<4 {
            if i != 1 {
                XCTAssertEqual(board[1][i], 1)
                XCTAssertEqual(board[i][1], 1)
            }
        }
        
        // diagonal checks
        XCTAssertEqual(board[0][0], 1)
        XCTAssertEqual(board[2][2], 1)
        
        // anti-diagonal checks
        XCTAssertEqual(board[0][2], 1)
        XCTAssertEqual(board[2][0], 1)
    }

    func testCannotPlaceOnOccupiedSquare() throws {
        let engine = GameEngine(boardSize: 4)
        
        let pos = Position(x: 1, y: 1)
        _ = try engine.place(figure: QueenFigure(position: pos))
        
        XCTAssertThrowsError(try engine.place(figure: QueenFigure(position: pos))) { error in
            guard let placementError = error as? PlacementError else {
                XCTFail("error: \(error)")
                return
            }
            XCTAssertEqual(placementError, .occupied)
        }
    }
    
    func testRemoveQueenRecomputesAttacks() throws {
        let engine = GameEngine(boardSize: 4)
        
        let pos1 = Position(x: 0, y: 0)
        let pos2 = Position(x: 3, y: 1)
        
        _ = try engine.place(figure: QueenFigure(position: pos1))
        _ = try engine.place(figure: QueenFigure(position: pos2))
        
        let result = engine.remove(at: pos1)
        
        XCTAssertEqual(result.occupiedPositions.count, 1)
        XCTAssertEqual(result.occupiedPositions.first, pos2)
        
        let board = result.newBoard
        XCTAssertEqual(board[0][2], 0)
    }

    func testResetClearsBoardAndFigures() throws {
        let engine = GameEngine(boardSize: 4)
        _ = try engine.place(figure: QueenFigure(position: Position(x: 1, y: 1)))
        
        engine.reset()
        
        XCTAssertTrue(engine.occupiedPosistions.isEmpty)
        for row in engine.currentBoard {
            XCTAssertTrue(row.allSatisfy { $0 == 0 })
        }
    }
}
