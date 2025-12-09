# NQueens
An iOS application where the player plays a puzzle game based on the N-Queens problem. The user’s goal is to place n queens on an nxn chessboard such that no two queens threaten each other (no same row, column, or diagonal).

---

## Features

- Choose board size - minimum 4, maximum based on the screen size
- Chessboard:
  - Tap on the chessboard to place the queen on it
  - Tap again the same square to remove it
- Conflicting squares are highlighted in red color
- Invalid moves trigger chessboard shake and error sound
- Live info provided:
  - Queens placed on the board
  - Queens left
  - Live time
  - The best time for this board size (n)
 - Win screen inclluding your time and the best time

## Architecture

- **Engine**
  - 'GameEngine' and 'GameEngineImpl'
  - 'Figure' and 'QueenFigure'
  - 'Position', 'PlacementResult' and 'Placement Error'
  - Keeps an `[[Int]]` attack map and enforces valid queen placement
 
- **ViewModel**
  - 'GameViewModel'
  - Owns the engine instance, state of the board, timers, the best times and winning logic
  - Handles taps and triggers feedback (sounds and haptics)
 
- **UI**
  - 'GameView', 'ChessBoardView', 'ChessSquareView', 'WinScreenView'
  - SwiftUI
 
---

## Unit Tests

Includes tests for:
  - Engine
  - ViewModel

---

## Requirements

- XCode 15+
- iOS 16+
- Swift 5+

---

## How to run the project

1. Open the project in XCode.
2. Choose a simulaor or an external device (iPhone or iPad).
3. Run it with `⌘R`.
