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
    @Binding var selectedStock: Stock
    @State var selectedStockQty: Int
    var resources: GameResources
    @State var editableStockQty: Int = 0
    
    init(selectedStock: Binding<Stock>, selectedStockQty: Int, resources: GameResources) {
        self._selectedStock = selectedStock
        self.selectedStockQty = selectedStockQty
        self.resources = resources
        _editableStockQty = State(initialValue: selectedStockQty)
    }
    
    var body: some View {
    
        NavigationView {
            ZStack {
                Color(uiColor: .secondarySystemBackground).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        //logo, price & price change
                        VStack(spacing: 8) {
                            InventoryDetailMain(imageName: selectedStock.symbol, price: selectedStock.lastPrice, change: selectedStock.change, changePercentage: selectedStock.changePercentage)
                        }
                        
                        
                        //chart
                        VStack(alignment: .leading) {
                            StockDetailChart(selectedStock: selectedStock)
                        }
                        .padding()
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(12)
                        
                        
                        // Details Section
                        VStack(alignment: .leading, spacing: 12) {
                            RaidDetailInfo(label: "Specialty", value: "Mac, Apple Watch, Iphone")
                            RaidDetailInfo(label: "Stock", value: "\(selectedStockQty) \(selectedStock.symbol) Shares")
                        }
                        .padding()
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(12)
                        
                        HStack {
                            TextField("Quantity", value: $editableStockQty, format: .number)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder) // Recommended for visibility
                                .padding()
                                
                            Spacer()
                            Button(action: {
                                SellStock()
                            }) {
                                Text("Sell \(editableStockQty) Stocks")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(12)
                            }
                        }
                        .padding()
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(12)
                        
                        
                    }
                    .padding()
                }
            }
            .navigationTitle("\(selectedStock.symbol) Inventory Detail")
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
        if (selectedStockQty >= editableStockQty) {
            let expectedSell = Double(editableStockQty) * selectedStock.lastPrice
            if (expectedSell > 0) {
                let dollars_qty = resources.dollars + expectedSell
                resources.updateDollars(dollars_qty)
                let ownedStock = OwnedStock(stock: selectedStock, quantity: editableStockQty * -1)
                resources.addOrUpdate(ownedStock: ownedStock)
                
            }
            dismiss()
        }
    }
}





#Preview {
    
//    StockInventoryDetail(selectedStock: OwnedStock(stock: SeedData.stocks[0], quantity: 1000), resources: GameResources())
}
//pass resource as a binding result
// when launch operation, apply confirmation dialog
//

