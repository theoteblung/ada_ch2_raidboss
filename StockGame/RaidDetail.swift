//
//  AttackDetailSheetV1.swift
//  StockGame
//
//  Created by Christofer Theodore on 21/04/26.
//
import SwiftUI
import Charts
// MARK: - Detailed Sheet (Page 2)
struct RaidDetail: View {
    @Environment(\.dismiss) private var dismiss
    @State var selectedStock: Stock
    @State var commodities: [Commodity]
    let resources: GameResources
    
    @State var selectedRaidAttack: RaidAttack?
    
    var raidAttacks: [RaidAttack] = [
        RaidAttack(name: "Digital Intel", dollars: 0, gold: 1, silver: 10, oil: 0, icon: "laptopcomputer"),
        RaidAttack(name: "Supply Sabotage", dollars: 0, gold: 3, silver: 0, oil: 10, icon: "airplane"),
        RaidAttack(name: "Hostile Buyout", dollars: 10000, gold: 0, silver: 0, oil: 0, icon: "dollarsign.circle"),
    ]
    var body: some View {
    
        NavigationView {
            ZStack {
                Color(uiColor: .secondarySystemBackground).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        //logo, price & price change
                        VStack(spacing: 8) {
                            RaidDetailMain(selectedStock: selectedStock)
                        }
                        
                        
                        //chart
                        VStack(alignment: .leading) {
                            RaidDetailChart(selectedStock: selectedStock)
                        }
                        .padding()
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(12)
                        
                        
                        
                        
                        // Details Section
                        VStack(alignment: .leading, spacing: 12) {
                            RaidDetailInfo(label: "Specialty", value: "Mac, Apple Watch, Iphone")
                            RaidDetailInfo(label: "Potential Reward", value: "100 \(selectedStock.symbol) Shares")
                        }
                        .padding()
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(12)
                        
                        
                        // Raid Methods Selection
                        VStack(alignment: .leading, spacing: 15) {
                            
                            Text("Select Operation Method")
                                .font(.headline)
                            
                            HStack(spacing: 10) {
                                ForEach(raidAttacks) { raidAttack in
                                    RaidDetailMethod(raidAttack: raidAttack, selectedRaidAttack: $selectedRaidAttack)
                                }
                            }
                            
                            // Efficiency Comparison
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Cost: \(selectedRaidAttack?.costDescription ?? "-")")
                                    .font(.callout.bold())
                                    .foregroundColor(.orange)
                                if selectedRaidAttack != nil {
                                    Text("Return: \(getExpectedReturnDisplay())")
                                        .font(.callout.bold())
                                        .foregroundColor(getExpectedReturnColor())
                                } else {
                                    Text("Return: -")
                                }
                                Text("\(Image(systemName: "exclamationmark.triangle"))Notice: If you don't have required commodities, you will buy them directly at market prices.").font(.subheadline).foregroundColor(Color(.secondaryLabel))
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            launchRaid()
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
            .navigationTitle("\(selectedStock.symbol) Operation Detail")
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
    
    func getExpectedReturn() -> Double {
        var expectedReturn: Double = 0.0
        if (selectedRaidAttack != nil && goldInfo().priceHistory.count > 0 && silverInfo().priceHistory.count > 0 && oilInfo().priceHistory.count > 0) {
            if (selectedRaidAttack!.gold > 0) {
                expectedReturn += Double(selectedRaidAttack!.gold) * goldInfo().priceHistory.last!.price
            }
            if (selectedRaidAttack!.silver > 0) {
                expectedReturn += Double(selectedRaidAttack!.silver) * silverInfo().priceHistory.last!.price
            }
            if (selectedRaidAttack!.oil > 0) {
                expectedReturn += Double(selectedRaidAttack!.oil) * oilInfo().priceHistory.last!.price
            }
            let expectedReward = 100 * selectedStock.priceHistory.last!.price
            expectedReturn -= expectedReward
        }
        
        return expectedReturn
    }
    func getExpectedReturnDisplay() -> String {
        var expectedReturn = getExpectedReturn()
        var returnDisplay = ""
        if (expectedReturn > 0) {
            return "+$\(expectedReturn.formatted(.number.precision(.fractionLength(0))))"
        }else if (expectedReturn < 0) {
            expectedReturn = expectedReturn * -1
            return "-$\(expectedReturn.formatted(.number.precision(.fractionLength(0))))"
        }else {
            return returnDisplay
        }
    }
    func getExpectedReturnColor () -> Color {
        let expectedReturn = getExpectedReturn()
        if (expectedReturn > 0) {
            return .green
        }else if (expectedReturn < 0) {
            return .red
        }else {
            return .gray
        }
    }
    func goldInfo() -> Commodity {
        return commodities[0]
    }
    func silverInfo() -> Commodity {
        return commodities[1]
    }
    func oilInfo() -> Commodity {
        return commodities[2]
    }
    func launchRaid() {
        if (selectedRaidAttack != nil) {
            resources.gold -= Int(selectedRaidAttack!.gold)
            resources.silver -= Int(selectedRaidAttack!.silver)
            resources.oil -= Int(selectedRaidAttack!.oil)
            resources.dollars -= Double(selectedRaidAttack!.dollars)
            
            //calculate minus to buyout from current market price
            if (resources.gold < 0) {
                resources.dollars += Double(resources.gold) * goldInfo().priceHistory.last!.price
                resources.gold = 0
            }
            if (resources.silver < 0) {
                resources.dollars += Double(resources.silver) * silverInfo().priceHistory.last!.price
                resources.silver = 0
            }
            if (resources.oil < 0) {
                resources.dollars += Double(resources.gold) * oilInfo().priceHistory.last!.price
                resources.oil = 0
            }
            dismiss()
        }
    }
}





#Preview {
    RaidDetail(selectedStock: SeedData.stocks[0], commodities: SeedData.commodities, resources: GameResources())
}
//pass resource as a binding result
// when launch operation, apply confirmation dialog
//

