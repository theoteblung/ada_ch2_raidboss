//
//  GameTimeModel.swift
//  StockGame
//
//  Created by Fadil Himawan on 20/04/26.
//
import SwiftUI
// MARK: - Game Time
struct GameTime {
    var startDate: Date = Date()
    var timeMultiplier: Double = 120 // 1 real second = 2 game minutes

    var currentDate: Date {
        let elapsed = Date().timeIntervalSince(startDate)
        return startDate.addingTimeInterval(elapsed * timeMultiplier)
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: currentDate)
    }

    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: currentDate)
    }
}
