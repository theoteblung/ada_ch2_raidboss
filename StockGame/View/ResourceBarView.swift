//
//  ResourceBar.swift
//  StockGame
//
//  Created by Fadil Himawan on 21/04/26.
//

import SwiftUI

struct ResourceBar: View {
    var resources: GameResources
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            ResourceItem(iconString: "💰", amount: formattedDollar(resources.dollars))
            
            HStack(spacing: 10) {
                ResourceItem(icon: .gold, amount: "\(resources.gold)")
                ResourceItem(icon: .silver, amount: "\(resources.silver)")
                ResourceItem(iconString: "🛢️", amount: "\(resources.oil)")
            }
        }
    }
    
    private func formattedDollar(_ value: Double) -> String {
        if value >= 1_000_000 {
            return String(format: "%.1fM", value / 1_000_000)
        } else if value >= 1_000 {
            return String(format: "%.1fK", value / 1_000)
        } else {
            return String(format: "%.0f", value)
        }
    }
}

struct ResourceItem: View {
    var icon: ImageResource?
    var iconString: String?
    var amount: String
    
    var body: some View {
        HStack(spacing: 3) {
            if icon != nil {
                Image(icon!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            } else if iconString != nil {
                Text(iconString!)
                    .font(.system(size: 14))
            }
            Text(amount)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.ultraThinMaterial, in: Capsule())
    }
}

#Preview {
    let resources = GameResources()
    
    ResourceBar(resources: resources)
}

#Preview {
    ResourceItem(icon: .gold, amount: "100")
}
