//
//  NewsEffectModel.swift
//  StockGame
//
//  Created by Christofer Theodore on 20/04/26.
//
import SwiftUI
struct NewsEffect {
    enum EffectDirection { case up, down }
    var type: ItemType
    var direction: EffectDirection
    var magnitude: Double
}
