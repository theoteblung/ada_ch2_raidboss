//
//  CommodityInventoryDetail.swift
//  StockGame
//
//  Created by Christofer Theodore on 22/04/26.
//

import SwiftUI
import Charts
// MARK: - Detailed Sheet (Page 2)
struct CommodityInventoryDetail: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCommodity: Commodity
    let resources: GameResources
    @State private var qty = 0
    var body: some View {
    
        NavigationView {
            ZStack {
                Color(uiColor: .secondarySystemBackground).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        //logo, price & price change
                        VStack(spacing: 8) {
                            InventoryDetailMain(imageName: selectedCommodity.symbol, price: selectedCommodity.lastPrice, change: selectedCommodity.change, changePercentage: selectedCommodity.changePercentage)
                        }
                        
                        
                        //chart
                        VStack(alignment: .leading) {
                            CommodityDetailChart(selectedStock: selectedCommodity)
                        }
                        .padding()
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(12)
                        
                        
                        // Details Section
                        VStack(alignment: .leading, spacing: 12) {
                            RaidDetailInfo(label: "Specialty", value: "Mac, Apple Watch, Iphone")
                            RaidDetailInfo(label: "Stock", value: "\(resources.gold) \(selectedCommodity.symbol)")
                            
                            
                        }
                        .padding()
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(12)
                        
                        HStack {
                            TextField("Quantity", value: $qty, format: .number)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder) // Recommended for visibility
                                .padding()
                                
                            Spacer()
                            Button(action: {
                                BuyCommodity()
                            }) {
                                Text("Buy \n \(qty) \(selectedCommodity.name)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(12)
                            }
                            Spacer()
                            Button(action: {
                                SellCommodity()
                            }) {
                                Text("Sell \n \(qty) \(selectedCommodity.name)")
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
            .navigationTitle("\(selectedCommodity.symbol) Inventory Detail")
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
    
    func SellCommodity() {
        if (resources.dollars > 0) {
            let ammount: Int = qty
            print("qty: \(qty)")
            print("amm \(ammount)")
            if (selectedCommodity.symbol=="GLD") {
                let expectedSell = Double(ammount) * selectedCommodity.lastPrice
                if (expectedSell > 0) {
                    let dollars_qty = resources.dollars + expectedSell
                    resources.updateGold(resources.gold - ammount)
                    resources.updateDollars(dollars_qty)
                }
            }else if (selectedCommodity.symbol=="SLV") {
                let expectedSell = Double(ammount) * selectedCommodity.lastPrice
                if (expectedSell > 0) {
                    let dollars_qty = resources.dollars + expectedSell
                    resources.updateSilver(resources.silver - ammount)
                    resources.updateDollars(dollars_qty)
                }
            }else if (selectedCommodity.symbol=="OIL") {
                let expectedSell = Double(ammount) * selectedCommodity.lastPrice
                if (expectedSell > 0) {
                    let dollars_qty = resources.dollars + expectedSell
                    resources.updateOil(resources.oil - ammount)
                    resources.updateDollars(dollars_qty)
                }
            }
            
            dismiss()
        }
    }
    func BuyCommodity() {
        if (resources.dollars > 0) {
            let ammount: Int = qty
            if (selectedCommodity.symbol=="GLD") {
                let expectedBuy = Double(ammount) * selectedCommodity.lastPrice
                if (expectedBuy > 0) {
                    let dollars_qty = resources.dollars - expectedBuy
                    resources.updateGold(resources.gold + ammount)
                    resources.updateDollars(dollars_qty)
                }
            }else if (selectedCommodity.symbol=="SLV") {
                let expectedBuy = Double(ammount) * selectedCommodity.lastPrice
                if (expectedBuy > 0) {
                    let dollars_qty = resources.dollars - expectedBuy
                    resources.updateSilver(resources.silver + ammount)
                    resources.updateDollars(dollars_qty)
                }
            }else if (selectedCommodity.symbol=="OIL") {
                let expectedBuy = Double(ammount) * selectedCommodity.lastPrice
                if (expectedBuy > 0) {
                    let dollars_qty = resources.dollars - expectedBuy
                    resources.updateOil(resources.oil + ammount)
                    resources.updateDollars(dollars_qty)
                }
            }
            
            dismiss()
        }
    }
}





#Preview {
//    CommodityInventoryDetail(selectedCommodity: SeedData.commodities[0], resources: GameResources())
}
//pass resource as a binding result
// when launch operation, apply confirmation dialog
//

