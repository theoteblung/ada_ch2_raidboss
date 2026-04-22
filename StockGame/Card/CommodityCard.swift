//
//  CommodityCard.swift
//  StockGame
//
//  Created by Fadil Himawan on 20/04/26.
//

import SwiftUI
import Charts

struct CommodityCard: View {

    var commodity: Commodity

    var body: some View {
        HStack {
                Text(commodity.name)
                    .font(.title3.bold())
                    .lineLimit(1)
            .frame(width: 100, alignment: .leading)
            Spacer()
            Chart {
                ForEach(commodity.priceHistory, id: \.date) { item in
                    AreaMark(x: .value("Date", item.date), y: .value("Price", item.price))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: .init(colors: [commodity.statusColor.opacity(0.5), .clear]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    LineMark(x: .value("Date", item.date), y: .value("Price", item.price))
                        .foregroundStyle(commodity.statusColor)
                    RuleMark(
                        y: .value("Threshold", 200)
                    )
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [10, 5]))
                    .foregroundStyle(commodity.statusColor)
                }
            }
            .frame(width: 100, height: 50)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            VStack(alignment: .trailing) {
                Text("\(commodity.lastPrice, specifier: "%.2f")")
                Button {

                } label: {
                    Text("\(commodity.change, specifier: "%.2f")").foregroundStyle(.white)
                        .font(.system(size: 14, weight: .bold))
                        .padding(.horizontal, 4)

                }

                .frame(width: 60, alignment: .trailing)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(commodity.statusColor)
                )

            }
        }
    }
}

#Preview {
    let commodity = Commodity.init(
        name: "Oil",
        symbol: "OIL",
        category: .energy,
        priceHistory: []
    )
    
    CommodityCard(commodity: commodity)
}

