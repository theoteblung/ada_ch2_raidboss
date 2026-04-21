//
//  GameResourcesModel.swift
//  StockGame
//
//  Created by Christofer Theodore on 20/04/26.
//

import SwiftUI
import Observation

@Observable
final class GameResources {
    var dollars: Double = 10_000.00
    var gold: Int = 0
    var silver: Int = 0
}
