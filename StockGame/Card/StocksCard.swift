//
//  StocksCard.swift
//  StockGame
//
//  Created by Fadil Himawan on 20/04/26.
//

import SwiftUI
import Charts

struct StocksCard: View {
    
    var stock: Stock
    var total: Int?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(stock.symbol)
                    .font(.title2.bold())
                    .lineLimit(1)
                Text(stock.name)
                    .lineLimit(1)
                    .foregroundStyle(.gray)
            }.frame(width: 100, alignment: .leading)
            Spacer()
            
            //chart
            Chart {
                ForEach(stock.priceHistory, id: \.date) { item in
                    AreaMark(x: .value("Date", item.date), y: .value("Price", item.price))
                        .foregroundStyle(
                            LinearGradient(gradient: .init(colors: [stock.statusColor.opacity(0.5), .clear]), startPoint: .top, endPoint:
                                    .bottom)
                        )
                    LineMark(x: .value("Date", item.date), y: .value("Price", item.price))
                        .foregroundStyle(stock.statusColor)
                    RuleMark(
                        y: .value("Threshold", 200)
                    )
                    .lineStyle(StrokeStyle(lineWidth: 2, dash : [10,5]))
                    .foregroundStyle(stock.statusColor)
                }
            }
            .frame(width: 100, height: 50)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            
            if total != nil {
                VStack(alignment: .trailing) {
                    Text("Total")
                    
                    Text("\(total!)").foregroundStyle(.white)
                        .font(.system(size: 14, weight: .bold))
                        .padding(.horizontal, 4)
                        .frame(width: 60, alignment: .trailing)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(stock.statusColor)
                        )
                    
                }
            } else {
                VStack(alignment: .trailing) {
                    Text("\(stock.lastPrice, specifier: "%.2f")")
                    Button {
                        
                    } label: {
                        Text("\(stock.change, specifier: "%.2f")").foregroundStyle(.white)
                            .font(.system(size: 14, weight: .bold))
                            .padding(.horizontal, 4)
                        
                    }
                    
                    .frame(width: 60, alignment: .trailing)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(stock.statusColor)
                    )
                }
            }
        }
    }
}

#Preview {
    let stock = SeedData.stocks.randomElement()!
    
    StocksCard(stock: stock, total: 100)
}
