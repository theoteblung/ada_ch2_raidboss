//
//  GameTimeModel.swift
//  StockGame
//
//  Created by Fadil Himawan on 20/04/26.
//
import SwiftUI
import Observation

@Observable
final class GameTime {
    var startDate: Date = Date()
    var timeMultiplier: Double = 15 * 60 // 1 real second = 15 game minute

    func currentDate(at now: Date) -> Date {
        let elapsed = now.timeIntervalSince(startDate)
        return startDate.addingTimeInterval(elapsed * timeMultiplier)
    }

    func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: date)
    }

    func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
