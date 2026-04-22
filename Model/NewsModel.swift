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
    
    func startRotation(interval: TimeInterval = 8) {
        guard rotationTask == nil, !items.isEmpty else { return }
        rotationTask = Task { @MainActor [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(interval))
                guard let self, !Task.isCancelled else { break }
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.transition = false
                }
                try? await Task.sleep(for: .seconds(0.5))
                guard !Task.isCancelled else { break }
                self.currentIndex = (self.currentIndex + 1) % self.items.count
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.transition = true
                }
            }
        }
    }
    
    func stopRotation() {
        rotationTask?.cancel()
        rotationTask = nil
    }
}
