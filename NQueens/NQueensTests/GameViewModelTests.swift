//
//  GameViewModelTests.swift
//  NQueens
//
//  Created by Magdalena Pamuła-Posz on 09/12/2025.
//

import XCTest
@testable import NQueens

final class GameViewModelTests: XCTestCase {

    func testNewGameInitializesState() {
        let feedbackProvider = MockFeedbackProvider()
        let vm = GameViewModel(feedbackProvider: feedbackProvider)
        
        vm.boardSize = 4
        vm.newGame()
        
        XCTAssertNotNil(vm.game)
        XCTAssertEqual(vm.effectiveBoardSize, 4)
        XCTAssertEqual(vm.currentBoard.count, 4)
        XCTAssertTrue(vm.figurePositions.isEmpty)
        XCTAssertNotNil(vm.startDate)
        XCTAssertNil(vm.lastElapsed)
    }
    
    func testRestartClearsQueensAndResetsTimer() {
        let feedbackProvider = MockFeedbackProvider()
        let vm = GameViewModel(feedbackProvider: feedbackProvider)
        
        vm.boardSize = 4
        vm.newGame()

        vm.handleTap(x: 0, y: 0)
        XCTAssertEqual(vm.figurePositions.count, 1)

        vm.restart()
        
        XCTAssertEqual(vm.figurePositions.count, 0)
        XCTAssertNotNil(vm.startDate)
        XCTAssertNil(vm.lastElapsed)
        
        for row in vm.currentBoard {
            XCTAssertTrue(row.allSatisfy { $0 == 0 })
        }
    }
    
    func testHandleTapPlacesQueen() {
        let feedbackProvider = MockFeedbackProvider()
        let vm = GameViewModel(feedbackProvider: feedbackProvider)
        
        vm.boardSize = 4
        vm.newGame()
        
        vm.handleTap(x: 0, y: 0)
        XCTAssertEqual(vm.figurePositions.count, 1)
        XCTAssertEqual(feedbackProvider.placeCount, 1)
    }
    
    func testHandleTapRemovesQueenWhenAlreadyOccupied() {
        let feedbackProvider = MockFeedbackProvider()
        let vm = GameViewModel(feedbackProvider: feedbackProvider)
        
        vm.boardSize = 4
        vm.newGame()

        vm.handleTap(x: 0, y: 0)
        XCTAssertEqual(vm.figurePositions.count, 1)
        XCTAssertEqual(feedbackProvider.placeCount, 1)

        vm.handleTap(x: 0, y: 0)
        XCTAssertEqual(vm.figurePositions.count, 0)
        XCTAssertEqual(feedbackProvider.removeCount, 1)
    }
    
    func testInvalidMoveTriggersShakeAndErrorFeedback() {
        let feedbackProvider = MockFeedbackProvider()
        let vm = GameViewModel(feedbackProvider: feedbackProvider)
        
        vm.boardSize = 4
        vm.newGame()
        
        vm.handleTap(x: 0, y: 0)
        XCTAssertEqual(vm.figurePositions.count, 1)
        XCTAssertEqual(feedbackProvider.placeCount, 1)
        
        let previousShake = vm.shakeValue
        
        vm.handleTap(x: 0, y: 1)
        
        XCTAssertEqual(vm.figurePositions.count, 1)
        XCTAssertTrue(vm.shakeValue > previousShake)
        XCTAssertEqual(feedbackProvider.errorCount, 1)
        XCTAssertEqual(feedbackProvider.errorNotifications, 1)
    }
    
    func testWinningUpdatesBestTimeAndShowsWinScreen() {
        let feedbackProvider = MockFeedbackProvider()
        let vm = GameViewModel(feedbackProvider: feedbackProvider)
        
        vm.boardSize = 4
        vm.newGame()
        
        vm.handleTap(x: 0, y: 1)
        vm.handleTap(x: 1, y: 3)
        vm.handleTap(x: 2, y: 0)
        vm.handleTap(x: 3, y: 2)
        
        XCTAssertEqual(vm.figurePositions.count, 4)
        XCTAssertTrue(vm.shouldShowWinScreen)
        XCTAssertNotNil(vm.lastElapsed)
        
        let best = vm.bestTimes[vm.effectiveBoardSize]
        XCTAssertNotNil(best)
        
        // win feedback
        XCTAssertEqual(feedbackProvider.winCount, 1)
        XCTAssertEqual(feedbackProvider.successNotifications, 1)
    }
}
