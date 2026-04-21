//
//  RaidView.swift
//  StockGame
//
//  Created by Fadil Himawan on 21/04/26.
//

import SwiftUI

struct RaidView: View {
    @Binding var stocks: [Stock]
    @Binding var commodities: [Commodity]
    
    let news: NewsStore
    let gameTime: GameTime
    let resources: GameResources
    
    
    @State var selectedType: ItemType = .stocks
    @State private var hasStartedNewsRotation = false
    @State private var lastAppliedNewsID: NewsItem.ID?
    
    @State private var isShowingDetailSheet: Bool = false
    
    private let newsTransitionTime: TimeInterval = 4 * 2 // in seconds
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading) {
                Text("News")
                    .padding(.horizontal)
                
                if !news.items.isEmpty {
                    NewsCard(item: news.items[news.currentIndex])
                        .padding(.horizontal)
                        .offset(y: news.transition ? 0 : -10)
                        .opacity(news.transition ? 1 : 0)
                        .onAppear {
                            guard !news.items.isEmpty else { return }
                            applyCurrentNewsEffectsIfNeeded()
                            guard !hasStartedNewsRotation else { return }
                            hasStartedNewsRotation = true
                            
                            Timer.scheduledTimer(withTimeInterval: newsTransitionTime, repeats: true) { _ in
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
                }
                
                List {
                    Menu {
                        ForEach(ItemType.allCases, id: \.self) { item in
                            Button(item.rawValue.capitalized) {
                                selectedType = item
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedType.rawValue.capitalized)
                            Button("", systemImage: "chevron.up.chevron.down") {
                                
                            }
                            
                        }
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        
                    }
                    
                    let shownList: [any Item] = selectedType == .commodities ? commodities : stocks
                    ForEach(shownList, id: \.id) { item in
                        Group {
                            if let stock = item as? Stock {
                                StocksCard(stock: stock)
                                    .sheet(isPresented: $isShowingDetailSheet) {
                                        AttackDetailSheetV1(isShowSheet: $isShowingDetailSheet, selectedStock: stock, commodities: commodities, resources: resources)
                                    }
                                .onTapGesture {
                                    isShowingDetailSheet.toggle()
                                }
                            } else if let commodity = item as? Commodity {
                                CommodityCard(commodity: commodity)
                            }
                        }
                        .swipeActions {
                            Button(role: .destructive) {} label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .onMove { from, to in
                        if selectedType == .commodities {
                            commodities.move(fromOffsets: from, toOffset: to)
                        } else {
                            stocks.move(fromOffsets: from, toOffset: to)
                        }
                    }
                    
                }
                .listStyle(.plain)
                
            }
            .onChange(of: news.currentIndex) {
                applyCurrentNewsEffectsIfNeeded()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    VStack(alignment: .leading) {
                        Text("Raid Boss")
                            .font(.title)
                        
                        TimelineView(.periodic(from: .now, by: 1)) { context in
                            let currentGameDate = gameTime.currentDate(at: context.date)
                            
                            HStack(spacing: 4) {
                                Text(gameTime.formattedDate(from: currentGameDate))
                                Text("·")
                                Text(gameTime.formattedTime(from: currentGameDate))
                            }
                        }
                    }
                    .frame(width: 120, alignment: .leading)
                    
                }
                .sharedBackgroundVisibility(.hidden)
                
                ToolbarItem(placement: .topBarTrailing) {
                    ResourceBar(resources: resources)
                }
                .sharedBackgroundVisibility(.hidden)
            }
            .preferredColorScheme(.dark)
            
            
        }
        
    }
    
    private func applyCurrentNewsEffectsIfNeeded() {
        guard news.items.indices.contains(news.currentIndex) else { return }
        
        let currentNews = news.items[news.currentIndex]
        guard currentNews.id != lastAppliedNewsID else { return }
        
        stocks = stocks.map { stock in
            applyEffects(currentNews.effects, to: stock)
        }
        
        commodities = commodities.map { commodity in
            applyEffects(currentNews.effects, to: commodity)
        }
        
        lastAppliedNewsID = currentNews.id
    }
    
    private func applyEffects(_ effects: [NewsEffect], to stock: Stock) -> Stock {
        guard let updatedPrice = updatedPrice(from: stock.lastPrice, category: stock.category, effects: effects) else {
            return stock
        }
        
        var updatedStock = stock
        updatedStock.priceHistory.append(
            PriceHistory(date: gameTime.currentDate(at: Date()), price: updatedPrice)
        )
        return updatedStock
    }
    
    private func applyEffects(_ effects: [NewsEffect], to commodity: Commodity) -> Commodity {
        guard let updatedPrice = updatedPrice(from: commodity.lastPrice, category: commodity.category, effects: effects) else {
            return commodity
        }
        
        var updatedCommodity = commodity
        updatedCommodity.priceHistory.append(
            PriceHistory(date: gameTime.currentDate(at: Date()), price: updatedPrice)
        )
        return updatedCommodity
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

struct ResourceBar: View {
    var resources: GameResources
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            ResourceItem(icon: "💰", amount: formattedDollar(resources.dollars))
            
            HStack(spacing: 10) {
                ResourceItem(icon: "🏅", amount: "\(resources.gold)")
                ResourceItem(icon: "🥈", amount: "\(resources.silver)")
                ResourceItem(icon: "🛢️", amount: "\(resources.oil)")
            }
        }
    }
    
    private func formattedDollar(_ value: Double) -> String {
        if value >= 1_000_000 {
            return String(format: "%.1fM", value / 1_000_000)
        } else if value >= 1_000 {
            return String(format: "%.1fK", value / 1_000)
        } else {
            return String(format: "%.0f", value)
        }
    }
}

struct ResourceItem: View {
    var icon: String
    var amount: String
    
    var body: some View {
        HStack(spacing: 3) {
            Text(icon)
                .font(.system(size: 14))
            Text(amount)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.ultraThinMaterial, in: Capsule())
    }
}

#Preview {
    @Previewable @State var stocks: [Stock] = SeedData.stocks
    @Previewable @State var commodities: [Commodity] = SeedData.commodities
    let news = NewsStore(items: SeedData.newsItems)
    
    let gameTime = GameTime()
    let resources = GameResources()
    
    RaidView(stocks: $stocks, commodities: $commodities, news: news, gameTime: gameTime, resources: resources)
}
