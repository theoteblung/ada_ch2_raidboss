//
//  SeedData.swift
//  StockGame
//
//  Created by Codex on 20/04/26.
//

import Foundation

enum SeedData {
    static let day: TimeInterval = 86_400

    static var stocks: [Stock] {
        [
            Stock(
                symbol: "PLTR",
                name: "Palantir Technologies",
                speciality: "Big data, Analytics, and Software",
                category: .technology,
                priceHistory: [
                    .init(date: Date().addingTimeInterval(day * -4), price: 21.40),
                    .init(date: Date().addingTimeInterval(day * -3), price: 22.15),
                    .init(date: Date().addingTimeInterval(day * -2), price: 23.30),
                    .init(date: Date().addingTimeInterval(day * -1), price: 24.10),
                    .init(date: Date(), price: 24.95),
                ]
            ),
            Stock(
                symbol: "JPM",
                name: "JPMorgan Chase",
                speciality: "Investment, Private borrow and lending",
                category: .finance,
                priceHistory: [
                    .init(date: Date().addingTimeInterval(day * -4), price: 181.80),
                    .init(date: Date().addingTimeInterval(day * -3), price: 180.20),
                    .init(date: Date().addingTimeInterval(day * -2), price: 178.60),
                    .init(date: Date().addingTimeInterval(day * -1), price: 179.40),
                    .init(date: Date(), price: 182.10),
                ]
            ),
            Stock(
                symbol: "NEM",
                name: "Newmont Corporation",
                speciality: "Fertility medication",
                category: .mining,
                priceHistory: [
                    .init(date: Date().addingTimeInterval(day * -4), price: 36.50),
                    .init(date: Date().addingTimeInterval(day * -3), price: 37.80),
                    .init(date: Date().addingTimeInterval(day * -2), price: 39.10),
                    .init(date: Date().addingTimeInterval(day * -1), price: 40.60),
                    .init(date: Date(), price: 41.25),
                ]
            ),
            Stock(
                symbol: "LMT",
                name: "Lockheed Martin",
                speciality: "Defense tech, Aerospace and Security",
                category: .defense,
                priceHistory: [
                    .init(date: Date().addingTimeInterval(day * -4), price: 432.00),
                    .init(date: Date().addingTimeInterval(day * -3), price: 438.20),
                    .init(date: Date().addingTimeInterval(day * -2), price: 444.80),
                    .init(date: Date().addingTimeInterval(day * -1), price: 451.60),
                    .init(date: Date(), price: 458.40),
                ]
            ),
            Stock(
                symbol: "XOM",
                name: "Exxon Mobil",
                speciality: "Energy and Petrochemical production",
                category: .energy,
                priceHistory: [
                    .init(date: Date().addingTimeInterval(day * -4), price: 108.20),
                    .init(date: Date().addingTimeInterval(day * -3), price: 111.40),
                    .init(date: Date().addingTimeInterval(day * -2), price: 114.90),
                    .init(date: Date().addingTimeInterval(day * -1), price: 113.10),
                    .init(date: Date(), price: 116.35),
                ]
            ),
            Stock(
                symbol: "ADM",
                name: "Archer-Daniels-Midland",
                speciality: "Oilseed, Corn, Human nutrition and Biofuels",
                category: .food,
                priceHistory: [
                    .init(date: Date().addingTimeInterval(day * -4), price: 57.40),
                    .init(date: Date().addingTimeInterval(day * -3), price: 58.90),
                    .init(date: Date().addingTimeInterval(day * -2), price: 60.10),
                    .init(date: Date().addingTimeInterval(day * -1), price: 61.30),
                    .init(date: Date(), price: 60.85),
                ]
            ),
        ]
    }

    static var commodities: [Commodity] {
        [
            Commodity(
                name: "Gold",
                symbol: "GLD",
                speciality: "Commodities, Mining and Metals",
                category: .mining,
                priceHistory: [
                    .init(date: Date().addingTimeInterval(day * -4), price: 195),
                    .init(date: Date().addingTimeInterval(day * -3), price: 210),
                    .init(date: Date().addingTimeInterval(day * -2), price: 190),
                    .init(date: Date().addingTimeInterval(day * -1), price: 210),
//                    .init(date: Date().addingTimeInterval(day), price: 259.20),
                ]
            ),
            Commodity(
                name: "Silver",
                symbol: "SLV",
                speciality: "Commodities, Mining and Metals",
                category: .mining,
                priceHistory: [
                    .init(date: Date().addingTimeInterval(day * -4), price: 120),
                    .init(date: Date().addingTimeInterval(day * -3), price: 110),
                    .init(date: Date().addingTimeInterval(day * -2), price: 90),
                    .init(date: Date().addingTimeInterval(day * -1), price: 100),
//                    .init(date: Date(), price: 60),
                ]
            ),
            Commodity(
                name: "Oil",
                symbol: "OIL",
                speciality: "Commodities, Mining and Energy",
                category: .energy,
                priceHistory: [
                    .init(date: Date().addingTimeInterval(day * -4), price: 100),
                    .init(date: Date().addingTimeInterval(day * -3), price: 80),
                    .init(date: Date().addingTimeInterval(day * -2), price: 60),
                    .init(date: Date().addingTimeInterval(day * -1), price: 120),
//                    .init(date: Date().addingTimeInterval(day), price: 259.20),
                ]
            ),
        ]
    }
    static var raidAttacks: [RaidAttack] = [
        RaidAttack(name: "Digital Intel", dollars: 0, gold: 1, silver: 10, oil: 0, icon: "laptopcomputer", tools: "Laptop", description: "Gather informations from enemy servers"),
        RaidAttack(name: "Supply Sabotage", dollars: 0, gold: 3, silver: 0, oil: 10, icon: "airplane", tools: "Airplane", description: "Gather supplies from enemy bases"),
        RaidAttack(name: "Hostile Buyout", dollars: 10000, gold: 0, silver: 0, oil: 0, icon: "dollarsign.circle", tools: "Money", description: "Gather enemy stock shares from the market"),
    ]

    static var newsItems: [NewsItem] {
        [
            .init(
                title: "Oil Surges on Supply Concerns",
                date: Date().addingTimeInterval(day * -1),
                description: "Global oil prices jumped as OPEC announced unexpected production cuts, raising fears of shortages ahead of the summer season.",
                effects: [
                    .init(category: .mining, direction: .up, magnitude: 0.05)
                ]
            ),
            .init(
                title: "Tech Stocks Rally on Earnings Beat",
                date: Date(),
                description: "Major tech companies reported better-than-expected quarterly results, driving a broad market rally in the sector.",
                effects: [
                    .init(category: .technology, direction: .up, magnitude: 0.08)
                ]
            ),
            .init(
                title: "Trade Tensions Escalate",
                date: Date().addingTimeInterval(day * -2),
                description: "New tariff announcements between major economies have rattled commodity markets, with gold and silver seeing sharp movements.",
                effects: [
                    .init(category: .defense, direction: .down, magnitude: 0.03),
                    .init(category: .food, direction: .down, magnitude: 0.04)
                ]
            ),
        ]
    }
}
