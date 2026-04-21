//
//  NewsEffectModel.swift
//  StockGame
//
//  Created by Christofer Theodore on 20/04/26.
//
import SwiftUI
struct NewsEffect {
    enum EffectDirection { case up, down }
    var category: ItemCategory
    var direction: EffectDirection
    var magnitude: Double
}
