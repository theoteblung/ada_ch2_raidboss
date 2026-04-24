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
    
    
    enum SelectedSheet: Identifiable {
        case ownedStock(OwnedStock)
        case commodity(Commodity) // e.g., a setting title

        var id: UUID {
            switch self {
            case .ownedStock(let ownedStock): return ownedStock.id
            case .commodity(let commodity): return commodity.id
            }
        }
    }
    @State private var selectedSheet: SelectedSheet?
    
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
                                    .onTapGesture {
                                        selectedSheet = .commodity(commodity)
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
                    case .stocks:
                        let shownList: [OwnedStock] = resources.ownedStocks
                        ForEach(shownList, id: \.id) { ownedStock in
                            Group {
                                StocksCard(stock: ownedStock.stock, total: ownedStock.quantity)
                                    .onTapGesture {
                                        selectedSheet = .ownedStock(ownedStock)
                                    }
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    resources.remove(ownedStock: ownedStock)
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
            .sheet(item: $selectedSheet, onDismiss: {
                
            }) { selected in
                switch selected {
                    case .ownedStock(let selectedOwnedStock):
//                        StockInventoryDetail(selectedStock: selectedOwnedStock, resources: resources)
                        if let index = stocks.firstIndex(where: { $0.id == selectedOwnedStock.stock.id }) {
                            StockInventoryDetail(selectedStock: $stocks[index], selectedStockQty: selectedOwnedStock.quantity, resources: resources)
                        }
                        
                    case .commodity(let selectedCommodity):
//                        CommodityInventoryDetail(selectedCommodity: selectedCommodity, resources: resources)
                        if let index = commodities.firstIndex(where: { $0.id == selectedCommodity.id }) {
                            CommodityInventoryDetail(selectedCommodity: $commodities[index], resources: resources)
                        }
                }
//                InventoryDetail(selectedStock: $selectedStock, selectedCommodity: $selectedCommodity, resources: resources)
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
