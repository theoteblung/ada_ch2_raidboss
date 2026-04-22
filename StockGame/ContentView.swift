//
//  ContentView.swift
//  StocksGame
//
//  Created by Fadil Himawan on 20/04/26.
//
/// TODO:
/// 1. Integrate acquire Commidity -> if confirmed put it inside gameResource
/// 2. Integrate RaidBoss -> after raid put it inside gameResource
/// 3. Check NewsModel

import SwiftUI

struct ContentView: View {
    @Binding var stocks: [Stock]
    @Binding var commodities: [Commodity]
    
    let news: NewsStore
    let gameTime: GameTime
    let resources: GameResources
    let newsInterval = 10.0
    
    var body: some View {
        VStack(spacing: 0) {
            TabView {
                RaidView(stocks: $stocks, commodities: $commodities, news: news, gameTime: gameTime, resources: resources)
                    .tabItem {
                        Label("Raid", systemImage: "flag.2.crossed")
                    }
                
                InventoryView(stocks: $stocks, commodities: $commodities, news: news, gameTime: gameTime, resources: resources)
                    .tabItem {
                        Label("Inventory", systemImage: "folder.badge.plus")
                    }
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: newsInterval, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.5)) {
                    news.transition = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    news.currentIndex = (news.currentIndex + 1) % news.items.count
                    withAnimation(.easeInOut(duration: 0.5)) {
                        news.transition = true
                    }
                }
            }

        }
        .onChange(of: news.currentIndex) {
            applyCurrentNewsEffectsIfNeeded()
        }
    }
    
    private func applyCurrentNewsEffectsIfNeeded() {
        guard news.items.indices.contains(news.currentIndex) else { return }
        
        let currentNews = news.items[news.currentIndex]
        
        stocks = stocks.map { stock in
            applyEffects(currentNews.effects, to: stock)
        }
        
        commodities = commodities.map { commodity in
            applyEffects(currentNews.effects, to: commodity)
        }
    }
    
    private func applyEffects<T: Item>(_ effects: [NewsEffect], to item: T) -> T {
        guard let updatedPrice = updatedPrice(from: item.lastPrice, category: item.category, effects: effects) else {
            return item
        }
        
        var updatedItem = item
        updatedItem.priceHistory.append(
            PriceHistory(date: gameTime.currentDate(at: Date()), price: updatedPrice)
        )
        return updatedItem
    }
    
    private func updatedPrice(from currentPrice: Double, category: ItemCategory, effects: [NewsEffect]) -> Double? {
        let matchingEffects = effects.filter { $0.category == category }
        guard !matchingEffects.isEmpty else { return nil }
        
        return matchingEffects.reduce(currentPrice) { price, effect in
            let multiplier = effect.direction == .up ? 1 + effect.magnitude : 1 - effect.magnitude
            return max(price * multiplier, 0)
        }
    }
}

#Preview {
    @Previewable @State var stocks: [Stock] = SeedData.stocks
    @Previewable @State var commodities: [Commodity] = SeedData.commodities
    let news = NewsStore(items: SeedData.newsItems)
    
    let gameTime = GameTime()
    let resources = GameResources()
    
    ContentView(stocks: $stocks, commodities: $commodities, news: news, gameTime: gameTime, resources: resources)
}
