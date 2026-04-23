//
//  InventoryDetailComponents.swift
//  StockGame
//
//  Created by Christofer Theodore on 22/04/26.
//

import SwiftUI
import Charts

struct InventoryDetailMain: View {
    var imageName: String
    var price: Double
    var change: Double
    var changePercentage: Double
    
    
    var body: some View {
        // Header & Price
        Image("\(imageName.lowercased())")
            .resizable()
            .frame(width: 100, height: 100)
            .font(.system(size: 60))
            .padding()
        
        Text("$\(price, specifier: "%.2f")")
            .font(.system(size: 44, weight: .bold, design: .rounded))
        
        Text("\(String(format: "%.2f", change))(\(String(format: "%.2f", changePercentage))%)")
            .foregroundColor(.green)
            .font(.headline)
        
    }
}

struct StockDetailChart: View {
    var selectedStock: Stock
    var body: some View {
        Text("Market Sentiment (6M)")
            .font(.caption.bold())
            .foregroundColor(.secondary)
//                            CandleStickView()
//                                .frame(height: 200)
        Chart {
            ForEach(selectedStock.priceHistory, id: \.date) { item in
                AreaMark(x: .value("Date", item.date), y: .value("Price", item.price))
                    .foregroundStyle(
                        LinearGradient(gradient: .init(colors: [selectedStock.statusColor.opacity(0.5), .clear]), startPoint: .top, endPoint:
                                .bottom)
                    )
                LineMark(x: .value("Date", item.date), y: .value("Price", item.price))
                    .foregroundStyle(selectedStock.statusColor)
                RuleMark(
                    y: .value("Threshold", selectedStock.avgPrice)
                )
                .lineStyle(StrokeStyle(lineWidth: 2, dash : [10,5]))
                .foregroundStyle(selectedStock.statusColor)
            }
        }
        .frame(height: 150)
        .padding(20)
        .preferredColorScheme(.dark)
        
    }
}

struct CommodityDetailChart: View {
    var selectedStock: Commodity
    var body: some View {
        Text("Market Sentiment (6M)")
            .font(.caption.bold())
            .foregroundColor(.secondary)
//                            CandleStickView()
//                                .frame(height: 200)
        Chart {
            ForEach(selectedStock.priceHistory, id: \.date) { item in
                AreaMark(x: .value("Date", item.date), y: .value("Price", item.price))
                    .foregroundStyle(
                        LinearGradient(gradient: .init(colors: [selectedStock.statusColor.opacity(0.5), .clear]), startPoint: .top, endPoint:
                                .bottom)
                    )
                LineMark(x: .value("Date", item.date), y: .value("Price", item.price))
                    .foregroundStyle(selectedStock.statusColor)
                RuleMark(
                    y: .value("Threshold", selectedStock.avgPrice)
                )
                .lineStyle(StrokeStyle(lineWidth: 2, dash : [10,5]))
                .foregroundStyle(selectedStock.statusColor)
            }
        }
        .frame(height: 150)
        .padding(20)
        .preferredColorScheme(.dark)
        
    }
}
