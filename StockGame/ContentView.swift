//
//  ContentView.swift
//  StocksGame
//
//  Created by Fadil Himawan on 20/04/26.
//
/// TODO:
/// 1. How to use observable -> move gameTime, resources, news
/// 2. Create example data -> news, commodities and stocks
/// 3. Think how news can affect stocks and commodities based on newsEffect
/// 4. Create new tab for InverntoryScreen


import SwiftUI

struct ContentView: View {
    @State private var stocks: [Stock] = SeedData.stocks
    @State private var commodities: [Commodity] = SeedData.commodities
    @State private var news = NewsStore(items: SeedData.newsItems)

    @State private var gameTime = GameTime()
    @State private var resources = GameResources()

    @State var selectedType: ItemType = .stocks
    
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
            }
            .preferredColorScheme(.dark)
            
            
        }

    }
}

// MARK: - Resource Bar
struct ResourceBar: View {
    var resources: GameResources

    var body: some View {
        HStack(spacing: 10) {
            ResourceItem(icon: "💰", amount: formattedDollar(resources.dollars))
            ResourceItem(icon: "🏅", amount: "\(resources.gold)")
            ResourceItem(icon: "🥈", amount: "\(resources.silver)")
            ResourceItem(icon: "🛢️", amount: "\(resources.oil)")
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
    ContentView()
}
