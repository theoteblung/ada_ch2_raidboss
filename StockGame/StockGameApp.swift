//
//  StockGameApp.swift
//  StockGame
//
//  Created by Fadil Himawan on 20/04/26.
//

import SwiftUI
import SwiftData

@main
struct StockGameApp: App {
    @State private var stocks: [Stock] = SeedData.stocks
    @State private var commodities: [Commodity] = SeedData.commodities
    
    let news = NewsStore(items: SeedData.newsItems)
    let gameTime = GameTime()
    let resources = GameResources()

    var body: some Scene {
        WindowGroup {
            ContentView(
                stocks: $stocks, commodities: $commodities, news: news, gameTime: gameTime, resources: resources
            )
        }
    }
}
