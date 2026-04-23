//
//  InventoryDetail.swift
//  StockGame
//
//  Created by Christofer Theodore on 22/04/26.
//

import SwiftUI
import Charts
// MARK: - Detailed Sheet (Page 2)
struct StockInventoryDetail: View {
    @Environment(\.dismiss) private var dismiss
    @State var selectedStock: OwnedStock
    let resources: GameResources
    
    var body: some View {
    
        NavigationView {
            ZStack {
                Color(uiColor: .secondarySystemBackground).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        //logo, price & price change
                        VStack(spacing: 8) {
                            InventoryDetailMain(imageName: selectedStock.stock.symbol, price: selectedStock.stock.priceHistory.last!.price, change: selectedStock.stock.change, changePercentage: selectedStock.stock.changePercentage)
                        }
                        
                        
                        //chart
                        VStack(alignment: .leading) {
                            StockDetailChart(selectedStock: selectedStock.stock)
                        }
                        .padding()
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(12)
                        
                        
                        // Details Section
                        VStack(alignment: .leading, spacing: 12) {
                            RaidDetailInfo(label: "Specialty", value: "Mac, Apple Watch, Iphone")
                            RaidDetailInfo(label: "Quantity", value: "\(selectedStock.quantity) \(selectedStock.stock.symbol) Shares")
                        }
                        .padding()
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(12)
                        
                        
                        
                        Button(action: {
                            SellStock()
                        }) {
                            Text("Sell Stocks")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("\(selectedStock.stock.symbol) Inventory Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("X") {
                        dismiss()
                    }
                }
            }
            
        }
    }
    func SellStock() {
        if (selectedStock.quantity > 0) {
            let expectedSell = Double(selectedStock.quantity) * selectedStock.stock.priceHistory.last!.price
            if (expectedSell > 0) {
                let dollars_qty = resources.dollars + expectedSell
                selectedStock.quantity = selectedStock.quantity * -1
                resources.updateDollars(dollars_qty)
                resources.addOrUpdate(ownedStock: selectedStock)
                
            }
            dismiss()
        }
    }
}





#Preview {
    StockInventoryDetail(selectedStock: OwnedStock(stock: SeedData.stocks[0], quantity: 1000), resources: GameResources())
}
//pass resource as a binding result
// when launch operation, apply confirmation dialog
//

