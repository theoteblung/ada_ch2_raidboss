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
    @State var selectedStock: Stock
    let resources: GameResources
    
    var body: some View {
    
        NavigationView {
            ZStack {
                Color(uiColor: .secondarySystemBackground).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        //logo, price & price change
                        
                        
                        
                        // Details Section
                        VStack(alignment: .leading, spacing: 12) {
                            RaidDetailInfo(label: "Specialty", value: "Mac, Apple Watch, Iphone")
                            RaidDetailInfo(label: "Potential Reward", value: "100 \(selectedStock.symbol) Shares")
                        }
                        .padding()
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(12)
                        
                        
                        
                        Button(action: {
                        }) {
                            Text("Launch Operation")
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
}





#Preview {
    RaidDetail(selectedStock: SeedData.stocks[0], commodities: SeedData.commodities, resources: GameResources())
}
//pass resource as a binding result
// when launch operation, apply confirmation dialog
//

