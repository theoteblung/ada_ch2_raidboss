//
//  RaidAttackModel.swift
//  StockGame
//
//  Created by Christofer Theodore on 20/04/26.
//

import SwiftUI
// MARK: - Game Resources
struct RaidAttack: Identifiable {
    var id: UUID = UUID()
    var name: String
    var dollars: Double
    var gold: Int = 0
    var silver: Int = 0
    var oil: Int = 0
    var tools: String
    var icon: String
}
