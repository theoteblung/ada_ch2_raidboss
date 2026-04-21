//
//  ContentView.swift
//  StocksGame
//
//  Created by Fadil Himawan on 20/04/26.
//
/// TODO:
/// 1. How to use observable -> move gameTime, resources, news ✅
/// 2. Create example data -> news, commodities and stocks ✅
/// 3. Think how news can affect stocks and commodities based on newsEffect
/// 4. Create new tab for InverntoryScreen
/// 5. Pass resource to DetailScreen


import SwiftUI

struct ContentView: View {
    @Binding var stocks: [Stock]
    @Binding var commodities: [Commodity]
    
    let news: NewsStore
    let gameTime: GameTime
    let resources: GameResources
    
    var body: some View {
        TabView {
            RaidView(stocks: $stocks, commodities: $commodities, news: news, gameTime: gameTime, resources: resources)
                .tabItem {
                    Label("Raid", systemImage: "flag.2.crossed")
                }
            
            RaidView(stocks: $stocks, commodities: $commodities, news: news, gameTime: gameTime, resources: resources)
                .tabItem {
                    Label("Inventory", systemImage: "folder.badge.plus")
                }
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
