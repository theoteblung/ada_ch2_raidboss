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
    
    @State private var selectedStock: Stock?
    
    private let newsTransitionTime: TimeInterval = 4 * 2 // in seconds
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading) {
                
                List {
                    if !news.items.isEmpty {
                        NewsCard(item: news.items[news.currentIndex], transition: news.transition)
                    }
                    
                    let shownList = stocks
                    
                    ForEach(shownList, id: \.id) { item in
                        StocksCard(stock: item)
                            .onTapGesture {
                                selectedStock = item
                            }
                    }
                    .onMove { from, to in
                        stocks.move(fromOffsets: from, toOffset: to)
                    }
                    
                }
                .listStyle(.plain)
                
            }
            .toolbarView(gameTime: gameTime, resources: resources)
            .sheet(item: $selectedStock, onDismiss: {
                
            }) { selected in
                AttackDetailSheetV1(selectedStock: selected, commodities: commodities, resources: resources)
            }
            .preferredColorScheme(.dark)
            
        }
        
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
