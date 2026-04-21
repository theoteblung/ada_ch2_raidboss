//
//  AttackDetailSheetV1.swift
//  StockGame
//
//  Created by Christofer Theodore on 21/04/26.
//
import SwiftUI
import Charts
// MARK: - Detailed Sheet (Page 2)
struct AttackDetailSheetV1: View {
    @State var stockDetail: Stock =
        Stock(symbol: "AAPL", name: "Apple Inc.", priceHistory: [
            .init(date: Date().addingTimeInterval(day * -4), price: 100),
            .init(date: Date().addingTimeInterval(day * -3), price: 210),
            .init(date: Date().addingTimeInterval(day * -2), price: 190),
            .init(date: Date().addingTimeInterval(day * -1), price: 210),
            .init(date: Date().addingTimeInterval(day), price: 259.20),
        ])
    @State private var selectedRaidAttackID: UUID? = nil
    @State private var selectedRaidInfo: RaidAttack? = nil
    var raidAttacks: [RaidAttack] = [
        RaidAttack(name: "Digital Intel", dollars: 0, gold: 1, silver: 10, oil: 0, tools: "Laptop", icon: "laptopcomputer"),
        RaidAttack(name: "Supply Sabotage", dollars: 0, gold: 3, silver: 0, oil: 10, tools: "Ship", icon: "airplane"),
        RaidAttack(name: "Hostile Buyout", dollars: 10000, gold: 0, silver: 0, oil: 0, tools: "People", icon: "dollarsign.circle"),
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .secondarySystemBackground).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Header & Price
                        VStack(spacing: 8) {
                            Image("apple")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .font(.system(size: 60))
                                .padding()
                            
                            Text("$\(stockDetail.priceHistory.last!.price, specifier: "%.2f")")
                                .font(.system(size: 44, weight: .bold, design: .rounded))
                            
                            Text("+123(+1.21%)")
                                .foregroundColor(.green)
                                .font(.headline)
                        }
                        
                        // Simulated Candlestick Chart
                        VStack(alignment: .leading) {
                            Text("Market Sentiment (6M)")
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
//                            CandleStickView()
//                                .frame(height: 200)
                            Chart {
                                ForEach(stockDetail.priceHistory, id: \.date) { item in
                                    AreaMark(x: .value("Date", item.date), y: .value("Price", item.price))
                                        .foregroundStyle(
                                            LinearGradient(gradient: .init(colors: [stockDetail.statusColor().opacity(0.5), .clear]), startPoint: .top, endPoint:
                                                    .bottom)
                                        )
                                    LineMark(x: .value("Date", item.date), y: .value("Price", item.price))
                                        .foregroundStyle(stockDetail.statusColor())
                                    RuleMark(
                                        y: .value("Threshold", 200)
                                    )
                                    .lineStyle(StrokeStyle(lineWidth: 2, dash : [10,5]))
                                    .foregroundStyle(stockDetail.statusColor())
                                }
                            }
                            .frame(height: 150)
                            .padding(20)
                            .preferredColorScheme(.dark)
                        }
                        .padding()
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(12)
                        
                        // Details Section
                        VStack(alignment: .leading, spacing: 12) {
                            DetailRow(label: "Specialty", value: "Mac, Apple Watch, Iphone")
                            DetailRow(label: "Potential Reward", value: "100 \(stockDetail.symbol) Shares")
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
                                    Button {
                                        selectedRaidAttackID = raidAttack.id
                                        selectedRaidInfo = raidAttack
                                    } label: {
                                        VStack {
                                            Image(systemName: raidAttack.icon)
                                            Text(raidAttack.name.split(separator: " ").last ?? "")
                                                .font(.caption2)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(selectedRaidAttackID == raidAttack.id ? Color.blue : Color.gray.opacity(0.2))
                                        .foregroundColor(selectedRaidAttackID == raidAttack.id ? .white : .primary)
                                        .cornerRadius(10)
                                    }
                                }
                            }
                            
                            // Efficiency Comparison
//                            VStack(alignment: .leading, spacing: 5) {
//                                Text(methods[selectedMethodIndex].description)
//                                    .font(.subheadline)
//                                    .foregroundColor(.secondary)
//                                Text("Cost: \(methods[selectedMethodIndex].costDescription)")
//                                    .font(.callout.bold())
//                                    .foregroundColor(.orange)
//                            }
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Selected Method")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("Cost: Selected Cost")
                                    .font(.callout.bold())
                                    .foregroundColor(.orange)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(10)
                        }
                        
                        Button(action: {}) {
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
            .navigationTitle("\(stockDetail.symbol) Operation Detail")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}

struct DetailRow: View {
    var label: String; var value: String
    
    var body: some View {
        HStack {
            Text(label).foregroundColor(.secondary)
            Spacer()
            Text(value).bold()
        }
        .font(.subheadline)
    }
}
#Preview {
    AttackDetailSheetV1()
}
//pass resource as a binding result
// when launch operation, apply confirmation dialog
//

