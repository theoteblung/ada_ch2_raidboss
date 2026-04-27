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
    @Binding var selectedStock: Stock
    @Binding var commodities: [Commodity]
    let resources: GameResources
    let totalReward: Int = 100
    
    var raidAttacks = SeedData.raidAttacks
    
    @State var showConfirmationDialog: Bool = false
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
                            RaidDetailInfo(label: "Specialty", value: "\(selectedStock.speciality)")
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
                                    RaidDetailMethod(raidAttack: raidAttack, selectedRaidAttack: $selectedStock.selectedRaidAttack)
                                }
                            }
                            
                            // Efficiency Comparison
                            VStack(alignment: .leading, spacing: 5) {
                                if selectedStock.selectedRaidAttack != nil {
                                    Text("Desc: \(selectedStock.selectedRaidAttack!.description) using \(selectedStock.selectedRaidAttack!.tools)").font(.callout)
                                        .foregroundColor(.white)
                                } else {
                                    Text("")
                                }
                                
                                
                                Text("Cost: \(selectedStock.selectedRaidAttack?.costDescription ?? "-")")
                                    .font(.callout.bold())
                                    .foregroundColor(.orange)
                                if selectedStock.selectedRaidAttack != nil {
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
//                            launchRaid()
                            validateRaid()
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
            // This shows centered alert, not attached popup
            .alert("System message", isPresented: $showConfirmationDialog) {
                
                Button("Yes") { launchRaid()}
                Button("No", role: .cancel) { }
            } message: {
                Text("Are you sure you want to launch operation on \(selectedStock.symbol)?")
            }
            .alert("System message", isPresented: $showMessageDialog) {
                
                Button("Close", role: .cancel) { }
            } message: {
                Text("\(messageContent)")
            }
            
        }
    }
    
    func getExpectedReturn() -> Double {
        var expectedReturn: Double = 0.0
        if (selectedStock.selectedRaidAttack != nil && goldInfo().priceHistory.count > 0 && silverInfo().priceHistory.count > 0 && oilInfo().priceHistory.count > 0) {
            if (selectedStock.selectedRaidAttack!.gold > 0) {
                expectedReturn += Double(selectedStock.selectedRaidAttack!.gold) * goldInfo().lastPrice
            }
            if (selectedStock.selectedRaidAttack!.silver > 0) {
                expectedReturn += Double(selectedStock.selectedRaidAttack!.silver) * silverInfo().lastPrice
            }
            if (selectedStock.selectedRaidAttack!.oil > 0) {
                expectedReturn += Double(selectedStock.selectedRaidAttack!.oil) * oilInfo().lastPrice
            }
            let expectedReward = Double(totalReward) * selectedStock.lastPrice
            expectedReturn = expectedReward - expectedReturn
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
    func validateRaid() {
        if (selectedStock.selectedRaidAttack != nil) {
            // calculate expected inventory
            var gold_qty = resources.gold - Int(selectedStock.selectedRaidAttack!.gold)
            var silver_qty = resources.silver - Int(selectedStock.selectedRaidAttack!.silver)
            var oil_qty = resources.oil - Int(selectedStock.selectedRaidAttack!.oil)
            var dollars_qty = resources.dollars - Double(selectedStock.selectedRaidAttack!.dollars)
            
            //calculate minus to buyout from current market price
            if (gold_qty < 0) {
                dollars_qty += Double(gold_qty) * goldInfo().lastPrice
                gold_qty = 0
            }
            if (silver_qty < 0) {
                dollars_qty += Double(silver_qty) * silverInfo().lastPrice
                silver_qty = 0
            }
            if (oil_qty < 0) {
                dollars_qty += Double(oil_qty) * oilInfo().lastPrice
                oil_qty = 0
            }
            if (dollars_qty >= 0) {
                showConfirmationDialog.toggle()
            }else {
                //placeholder for notification lack of resources
                messageContent = "You lack of resources to launch operation"
                showMessageDialog.toggle()
            }
            
        }else {
            //placeholder for selecting raid method
            messageContent = "Please select a raid method"
            showMessageDialog.toggle()
        }
    }
    func launchRaid() {
        if (selectedStock.selectedRaidAttack != nil) {
            // calculate expected inventory
            var gold_qty = resources.gold - Int(selectedStock.selectedRaidAttack!.gold)
            var silver_qty = resources.silver - Int(selectedStock.selectedRaidAttack!.silver)
            var oil_qty = resources.oil - Int(selectedStock.selectedRaidAttack!.oil)
            var dollars_qty = resources.dollars - Double(selectedStock.selectedRaidAttack!.dollars)
            
            //calculate minus to buyout from current market price
            if (gold_qty < 0) {
                dollars_qty += Double(gold_qty) * goldInfo().lastPrice
                gold_qty = 0
            }
            if (silver_qty < 0) {
                dollars_qty += Double(silver_qty) * silverInfo().lastPrice
                silver_qty = 0
            }
            if (oil_qty < 0) {
                dollars_qty += Double(oil_qty) * oilInfo().lastPrice
                oil_qty = 0
            }
            if (dollars_qty >= 0) {
                if (gold_qty != resources.gold) {
                    resources.updateGold(gold_qty)
                }
                if (silver_qty != resources.silver) {
                    resources.updateSilver(silver_qty)
                }
                if (oil_qty != resources.oil) {
                    resources.updateOil(oil_qty)
                }
                if (dollars_qty != resources.dollars) {
                    resources.updateDollars(dollars_qty)
                }
                var earnedStock: OwnedStock = OwnedStock(stock: selectedStock, quantity: totalReward)
                resources.addOrUpdate(ownedStock: earnedStock)
                
                dismiss()
            }else {
                //placeholder for notification lack of resources
                messageContent = "You lack of resources to launch operation"
                showMessageDialog.toggle()
            }
            
        }else {
            //placeholder for selecting raid method
            messageContent = "Please select a raid method"
            showMessageDialog.toggle()
        }
    }
}





//#Preview {
//    RaidDetail(selectedStock: SeedData.stocks[0], commodities: SeedData.commodities, resources: GameResources())
//}
//pass resource as a binding result
// when launch operation, apply confirmation dialog
//

