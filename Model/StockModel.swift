//
//  StockModel.swift
//  StockGame
//
//  Created by Fadil Himawan on 20/04/26.
//
import SwiftUI

enum ItemCategory: String, CaseIterable {
    case technology, finance, mining, defense, energy, food
}

enum ItemType: String, CaseIterable, Identifiable {
    case commodities, stocks
    var id: Self { self }
}

struct PriceHistory {
    var date: Date
    var price: Double
}

protocol Item: Identifiable {
    var id: UUID { get }
    var name: String { get }
    var symbol: String { get }
    var speciality: String { get }
    
    var category: ItemCategory { get }
    var priceHistory: [PriceHistory] { get set }
}

extension Item {
    var lastPrice: Double {
        priceHistory.last?.price ?? 0.0
    }
    var change: Double {
        lastPrice - (priceHistory.first?.price ?? 0.0)
    }
    var statusColor: Color {
        guard priceHistory.count >= 2 else { return .gray }
        return lastPrice > priceHistory.first!.price ? .green : .red
    }
}

// Model for our stock app
struct Stock: Item {
    let id = UUID()
    var symbol: String
    var name: String
    var speciality: String
    
    var category: ItemCategory
    var priceHistory: [PriceHistory]
    
    var selectedRaidAttack: RaidAttack?

    var change: Double {
        lastPrice - (priceHistory[0].price)
    }
    
    var changePercentage: Double {
        ((lastPrice - (priceHistory[0].price)) / (priceHistory[0].price)) * 100
    }

    var lastPrice: Double {
        priceHistory.last?.price ?? 0.0
    }

    var statusColor: Color {
        guard priceHistory.count >= 2 else { return .gray }
        return lastPrice > priceHistory[0].price ? .green : .red
    }
    
    var avgPrice: Double {
        let totalSum = priceHistory.reduce(0.0) { $0 + $1.price }
        let averagePrice = totalSum / Double(priceHistory.count)
        return averagePrice
    }
}

struct Commodity: Item {
    let id = UUID()
    var name: String
    var symbol: String
    var speciality: String
    
    var category: ItemCategory
    var priceHistory: [PriceHistory]
    
    var lastPrice: Double {
        priceHistory.last?.price ?? 0.0
    }
    
    var change: Double {
        lastPrice - (priceHistory[0].price)
    }
    
    var changePercentage: Double {
        ((lastPrice - (priceHistory[0].price)) / (priceHistory[0].price)) * 100
    }
    
    var avgPrice: Double {
        let totalSum = priceHistory.reduce(0.0) { $0 + $1.price }
        let averagePrice = totalSum / Double(priceHistory.count)
        return averagePrice
    }
}

struct OwnedStock: Identifiable, Equatable {
    static func == (lhs: OwnedStock, rhs: OwnedStock) -> Bool {
        lhs.stock.symbol == rhs.stock.symbol
    }
    
    let id: UUID = UUID()
    
    let stock: Stock
    var quantity: Int
    
    init(stock: Stock, quantity: Int) {
        self.stock = stock
        self.quantity = quantity
    }
}
