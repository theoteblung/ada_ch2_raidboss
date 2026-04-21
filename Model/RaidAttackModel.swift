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
    var icon: String
    var costDescription: String {
        var final_desc = ""
        if (gold > 0) {
            final_desc += "\(gold)🏅"
        }
        if (silver > 0) {
            final_desc += "\(silver)🥈"
        }
        if (oil > 0) {
            final_desc += "\(oil)🛢️"
        }
        if (dollars > 0) {
            final_desc += "\(dollars)💰"
        }
        return final_desc
    }
}
