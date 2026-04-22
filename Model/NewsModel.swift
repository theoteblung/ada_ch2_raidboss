//
//  NewsModel.swift
//  StockGame
//
//  Created by Fadil Himawan on 20/04/26.
//

import SwiftUI
import Observation

struct NewsEffect {
    enum EffectDirection { case up, down }
    var category: ItemCategory
    var direction: EffectDirection
    var magnitude: Double
}

struct NewsItem: Identifiable {
    let id = UUID()
    var title: String
    var date: Date
    var description: String
    var effects: [NewsEffect]
}

@Observable
final class NewsStore {
    var items: [NewsItem] = []
    var currentIndex: Int = 0
    var transition: Bool = true
    
    private var rotationTask: Task<Void, Never>?
    
    init(items: [NewsItem]) {
        self.items = items
    }
}
