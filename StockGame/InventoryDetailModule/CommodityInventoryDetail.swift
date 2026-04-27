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
    
    @State var showMessageDialog: Bool = false
    @State var messageContent: String = ""
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
                            RaidDetailInfo(label: "Description", value: "\(selectedCommodity.speciality)")
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
            .alert("System message", isPresented: $showMessageDialog) {
                
                Button("Close", role: .cancel) { }
            } message: {
                Text("\(messageContent)")
            }
            
        }
    }
    
    func SellCommodity() {
        if (resources.dollars > 0) {
            let ammount: Int = qty
            let expectedSell = Double(ammount) * selectedCommodity.lastPrice
            if (expectedSell <= 0) {
                messageContent = "Please input quantity"
                showMessageDialog.toggle()
            }else {
                if (selectedCommodity.symbol=="GLD") {
                        
                    if (ammount > resources.gold) {
                        messageContent = "You lack gold to sell"
                        showMessageDialog.toggle()
                    }else {
                        let dollars_qty = resources.dollars + expectedSell
                        resources.updateGold(resources.gold - ammount)
                        resources.updateDollars(dollars_qty)
                        
                        
                        dismiss()
                    }
                }else if (selectedCommodity.symbol=="SLV") {
                    if (ammount > resources.silver) {
                        messageContent = "You lack silver to sell"
                        showMessageDialog.toggle()
                    }else {
                        let dollars_qty = resources.dollars + expectedSell
                        resources.updateSilver(resources.silver - ammount)
                        resources.updateDollars(dollars_qty)
                        
                        
                        dismiss()
                    }
                }else if (selectedCommodity.symbol=="OIL") {
                    if (ammount > resources.oil) {
                        messageContent = "You lack oil to sell"
                        showMessageDialog.toggle()
                    }else {
                        let dollars_qty = resources.dollars + expectedSell
                        resources.updateOil(resources.oil - ammount)
                        resources.updateDollars(dollars_qty)
                        
                        
                        dismiss()
                    }
                }
            }
            
        }
    }
    func BuyCommodity() {
        if (resources.dollars > 0) {
            let ammount: Int = qty
            let expectedBuy = Double(ammount) * selectedCommodity.lastPrice
            let dollars_qty = resources.dollars - expectedBuy
            if (expectedBuy <= 0) {
                messageContent = "Please input quantity"
                showMessageDialog.toggle()
            }else if (dollars_qty < 0) {
                messageContent = "You lack of dollars to buy"
                showMessageDialog.toggle()
                
            }else {
                if (selectedCommodity.symbol=="GLD") {
                    resources.updateGold(resources.gold + ammount)
                    resources.updateDollars(dollars_qty)
                }else if (selectedCommodity.symbol=="SLV") {
                    resources.updateSilver(resources.silver + ammount)
                    resources.updateDollars(dollars_qty)
                }else if (selectedCommodity.symbol=="OIL") {
                    resources.updateOil(resources.oil + ammount)
                    resources.updateDollars(dollars_qty)
                    
                }
                dismiss()
            }
        }
    }
}





#Preview {
//    CommodityInventoryDetail(selectedCommodity: SeedData.commodities[0], resources: GameResources())
}
//pass resource as a binding result
// when launch operation, apply confirmation dialog
//

