//
//  InventoryView.swift
//  StockGame
//
//  Created by Fadil Himawan on 21/04/26.
//

import SwiftUI

struct InventoryView: View {
    @Binding var stocks: [Stock]
    @Binding var commodities: [Commodity]
    
    let news: NewsStore
    let gameTime: GameTime
    let resources: GameResources
    
    @State var selectedType: ItemType = .commodities
    
    @State private var selectedStock: Stock?
    
    private let newsTransitionTime: TimeInterval = 4 * 2 // in seconds
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading) {
                
                List {
                    if !news.items.isEmpty {
                        NewsCard(item: news.items[news.currentIndex], transition: news.transition)
                    }
                    
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
                    
                    switch selectedType {
                    case .commodities:
                        let shownList: [Commodity] = commodities
                        
                        ForEach(shownList, id: \.id) { commodity in
                            Group {
                                CommodityCard(commodity: commodity)
                            }
                        }
                        .onMove { from, to in
                            if selectedType == .commodities {
                                commodities.move(fromOffsets: from, toOffset: to)
                            } else {
                                stocks.move(fromOffsets: from, toOffset: to)
                            }
                        }
                    case .stocks:
                        let shownList: [OwnedStock] = resources.ownedStocks
                        ForEach(shownList, id: \.id) { stock in
                            Group {
                                StocksCard(stock: stock.stock, total: stock.quantity)
                                    .onTapGesture {
                                        selectedStock = stock.stock
                                    }
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    resources.remove(ownedStock: stock)
                                } label: {
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
                    
                }
                .listStyle(.plain)
            }
            .toolbarView(gameTime: gameTime, resources: resources)
            .sheet(item: $selectedStock, onDismiss: {
                
            }) { selected in
                RaidDetail(selectedStock: selected, commodities: commodities, resources: resources)
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
    
    InventoryView(stocks: $stocks, commodities: $commodities, news: news, gameTime: gameTime, resources: resources)
}
