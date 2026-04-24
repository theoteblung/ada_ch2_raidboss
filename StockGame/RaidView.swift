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
    
    @State var news: NewsStore
    let gameTime: GameTime
    let resources: GameResources
    @State var isPresented: Bool = false
    
    @State private var selectedStock: Stock?
    
    private let newsTransitionTime: TimeInterval = 4 * 2 // in seconds
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading) {
                
                List {
                    if !news.items.isEmpty {
                        NewsCard(item: news.items[news.currentIndex], transition: news.transition)
                    }
                    
                    ForEach(stocks.indices, id: \.self) { index in
                        StocksCard(stock: stocks[index])
                            .onTapGesture {
                                selectedStock = stocks[index]
                                
                            }
                    }
                    .onMove { from, to in
                        stocks.move(fromOffsets: from, toOffset: to)
                    }
                    
                }
                .listStyle(.plain)
                
            }
            .toolbarView(gameTime: gameTime, resources: resources)
//            .sheet(isPresented: $isPresented) {
//                RaidDetail(selectedStock: $stocks[selectedStock], commodities: commodities, resources: resources)
//            }
            .sheet(item: $selectedStock) { selected in
                if let index = stocks.firstIndex(where: { $0.id == selected.id }) {
                    RaidDetail(selectedStock: $stocks[index], commodities: $commodities, resources: resources)
                }
                
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
