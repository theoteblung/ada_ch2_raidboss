//
//  StockModel.swift
//  StockGame
//
//  Created by Fadil Himawan on 20/04/26.
//
import SwiftUI
// Model for our stock app
struct Stock: Identifiable {
    let id = UUID()
    var symbol: String
    var name: String
    var priceHistory: [PriceHistory]

    var change: Double {
        lastPrice - (priceHistory[0].price)
    }

    var lastPrice: Double {
        priceHistory.last?.price ?? 0.0
    }

    func statusColor() -> Color {
        guard priceHistory.count >= 2 else { return .gray }
        return lastPrice > priceHistory[0].price ? .green : .red
    }
}
