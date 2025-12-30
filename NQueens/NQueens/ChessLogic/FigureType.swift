//
//  FigureType.swift
//  NQueens
//
//  Created by Magdalena Pamuła-Posz on 30/12/2025.
//

import Foundation

enum FigureType: String, CaseIterable, Identifiable {
    case queen
    case knight
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .queen:  return "Queens"
        case .knight: return "Knights"
        }
    }
    
    var symbol: String {
        switch self {
        case .queen:  return "♛"
        case .knight: return "♞"
        }
    }
}
