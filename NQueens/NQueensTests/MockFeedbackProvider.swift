//
//  MockFeedbackProvider.swift
//  NQueens
//
//  Created by Magdalena Pamuła-Posz on 09/12/2025.
//

import Foundation
@testable import NQueens

final class MockFeedbackProvider: FeedbackProviderProtocol {
    private(set) var placeCount = 0
    private(set) var removeCount = 0
    private(set) var errorCount = 0
    private(set) var winCount = 0
    private(set) var successNotifications = 0
    private(set) var errorNotifications = 0
    
    func playPlace() {
        placeCount += 1
    }
    
    func playRemove() {
        removeCount += 1
    }
    
    func playError() {
        errorCount += 1
    }
    
    func playWin() {
        winCount += 1
    }
    
    func notifySuccess() {
        successNotifications += 1
    }
    
    func notifyError() {
        errorNotifications += 1
    }
}
