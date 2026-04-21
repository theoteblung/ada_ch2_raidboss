//
//  NewsCard.swift
//  StockGame
//
//  Created by Fadil Himawan on 20/04/26.
//

import SwiftUI

struct NewsCard: View {
    var item: NewsItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(item.title)
                    .font(.headline)
                Spacer()
                Text(item.date, style: .relative)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text(item.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            HStack(spacing: 6) {
                ForEach(item.effects, id: \.category) { effect in
                    Label {
                        Text("\(effect.category.rawValue.capitalized) \(effect.direction == .up ? "↑" : "↓") \(Int(effect.magnitude * 100))%")
                            .font(.caption2.bold())
                    } icon: {
                        Circle()
                            .fill(effect.direction == .up ? .green : .red)
                            .frame(width: 6, height: 6)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial, in: Capsule())
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NewsCard(item:
            .init(
                title: "Apple Inc. Q2 2024 Earnings: Analyst Upgrades, Revenue Beats Estimates",
                date: Date(),
                description: "Apple Inc. Q2 2024 Earnings: Analyst Upgrades, Revenue Beats Estimates",
                effects: [
                    NewsEffect
                        .init(category: .technology, direction: .up, magnitude: 0.05)
                ]
            )
    )
}
