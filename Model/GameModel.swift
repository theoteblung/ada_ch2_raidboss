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

@Observable
final class GameResources {
    var dollars: Double = 10_000.00
    var gold: Int = 0
    var silver: Int = 0
    var oil: Int = 0
    
    var ownedStocks: [OwnedStock] = []
    
    func remove(ownedStock: OwnedStock) {
        ownedStocks.removeAll { $0.id == ownedStock.id }
    }
    func addOrUpdate(ownedStock: OwnedStock) {
        if let index = ownedStocks.firstIndex(of: ownedStock) {
            ownedStocks[index].quantity += ownedStock.quantity
        }else {
            ownedStocks.append(ownedStock)
        }
    }
    
    func updateGold(_ amount: Int) {
        gold = amount
    }
    
    func updateSilver(_ amount: Int) {
        silver = amount
    }
    
    func updateOil(_ amount: Int) {
        oil = amount
    }
    
    func updateDollars(_ amount: Double) {
        dollars = amount
    }
}
