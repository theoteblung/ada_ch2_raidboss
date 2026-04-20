//
//  ContentView.swift
//  StocksGame
//
//  Created by Fadil Himawan on 20/04/26.
//


import SwiftUI
import Charts
enum ItemType: String, CaseIterable, Identifiable {
    case commodities, stocks
    var id: Self { self }
}
let day: Double = 86400



// MARK: - Game Resources
struct GameResources {
    var dollars: Double = 10_000.00
    var gold: Int = 0
    var silver: Int = 0
}

struct NewsEffect {
    enum EffectDirection { case up, down }
    var type: ItemType
    var direction: EffectDirection
    var magnitude: Double
}



struct ContentView: View {
    @State var stocks: [Stock] = [
        Stock(symbol: "AAPL", name: "Apple Inc.", priceHistory: [
            .init(date: Date().addingTimeInterval(day * -4), price: 100),
            .init(date: Date().addingTimeInterval(day * -3), price: 210),
            .init(date: Date().addingTimeInterval(day * -2), price: 190),
            .init(date: Date().addingTimeInterval(day * -1), price: 210),
            .init(date: Date().addingTimeInterval(day), price: 259.20),
        ]),
        Stock(symbol: "MSFT", name: "Microsoft Inc.", priceHistory: [
            .init(date: Date(), price: -1),
        ]),
    ]
    @State var commodities: [Stock] = [
        Stock(symbol: "AAPL", name: "Apple Inc.", priceHistory: [
            .init(date: Date().addingTimeInterval(day * -4), price: 100),
            .init(date: Date().addingTimeInterval(day * -3), price: 210),
            .init(date: Date().addingTimeInterval(day * -2), price: 190),
            .init(date: Date().addingTimeInterval(day * -1), price: 210),
            .init(date: Date().addingTimeInterval(day), price: 259.20),
        ]),
        Stock(symbol: "MSFT", name: "Microsoft Inc.", priceHistory: [
            .init(date: Date(), price: -1),
        ]),
    ]
    @State var gameTime = GameTime()
    @State var resources = GameResources()
    @State var showSheet = true
    @State var selectedType: ItemType = .commodities
    @State var newsItems: [NewsItem] = [
        .init(title: "Oil Surges on Supply Concerns", date: Date().addingTimeInterval(day * -1), description: "Global oil prices jumped as OPEC announced unexpected production cuts, raising fears of shortages ahead of the summer season.", effects: [
            .init(type: .commodities, direction: .up, magnitude: 0.05)
        ]),
        .init(title: "Tech Stocks Rally on Earnings Beat", date: Date(), description: "Major tech companies reported better-than-expected quarterly results, driving a broad market rally in the sector.", effects: [
            .init(type: .stocks, direction: .up, magnitude: 0.08)
        ]),
        .init(title: "Trade Tensions Escalate", date: Date().addingTimeInterval(day * -2), description: "New tariff announcements between major economies have rattled commodity markets, with gold and silver seeing sharp movements.", effects: [
            .init(type: .commodities, direction: .down, magnitude: 0.03),
            .init(type: .stocks, direction: .down, magnitude: 0.04)
        ]),
    ]
    @State var currentNewsIndex = 0
    @State var newsTransition = false

    var body: some View {

        NavigationStack {
            VStack(alignment: .leading) {
                Text("News")
                    .padding(.horizontal)

                NewsCard(item: newsItems[currentNewsIndex], transition: newsTransition)
                    .padding(.horizontal)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
                            withAnimation(.easeInOut(duration: 0.5)) {
                                newsTransition = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                currentNewsIndex = (currentNewsIndex + 1) % newsItems.count
                                newsTransition = false
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    newsTransition = true
                                }
                            }
                        }
                    }
                
                List {
                    Menu {
                        ForEach(ItemType.allCases, id: \.self) { item in
                            Button(item.rawValue.capitalized) {
                                selectedType = item
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedType.rawValue.capitalized)
                            Button("", systemImage: "chevron.up.chevron.down") {

                            }

                        }
                        .fontWeight(.bold)
                        .foregroundStyle(.white)

                    }

                    ForEach(stocks) { stock in
                        StocksCard(stock: stock)
                            .swipeActions {
                                Button(role: .destructive) {} label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }.onMove {
                        from, to in
                        stocks.move(fromOffsets: from, toOffset: to)
                    }

                }
                .listStyle(.plain)
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    VStack(alignment: .leading) {
                        Text("Raid Boss")
                            .font(.title)
                        HStack(spacing: 4) {
                            Text(gameTime.formattedDate).font(.subheadline).foregroundStyle(.secondary)
                            Text("·").foregroundStyle(.secondary)
                            Text(gameTime.formattedTime).font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                    .frame(width: 120, alignment: .leading)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                            // trigger view re-render for game clock
                        }
                    }

                }
                .sharedBackgroundVisibility(.hidden)
                ToolbarItem(placement: .topBarTrailing) {
                    ResourceBar(resources: resources)
                }
            }
            .preferredColorScheme(.dark)
            
            
        }

    }
}



struct NewsCard: View {
    var item: NewsItem
    var transition: Bool

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
                ForEach(item.effects, id: \.type) { effect in
                    Label {
                        Text("\(effect.type.rawValue.capitalized) \(effect.direction == .up ? "↑" : "↓") \(Int(effect.magnitude * 100))%")
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
        .offset(y: transition ? 0 : -10)
        .opacity(transition ? 1 : 0)
    }
}

struct StocksCard: View {

    var stock: Stock

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
                            LinearGradient(gradient: .init(colors: [stock.statusColor().opacity(0.5), .clear]), startPoint: .top, endPoint:
                                    .bottom)
                        )
                    LineMark(x: .value("Date", item.date), y: .value("Price", item.price))
                        .foregroundStyle(stock.statusColor())
                    RuleMark(
                        y: .value("Threshold", 200)
                    )
                    .lineStyle(StrokeStyle(lineWidth: 2, dash : [10,5]))
                    .foregroundStyle(stock.statusColor())
                }
            }
            .frame(width: 100, height: 50)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
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
                        .fill(stock.statusColor())
                )

            }
        }
    }
}





// MARK: - Resource Bar (Clash of Clans style)
struct ResourceBar: View {
    var resources: GameResources

    var body: some View {
        HStack(spacing: 10) {
            ResourceItem(icon: "💰", amount: formattedDollar(resources.dollars))
            ResourceItem(icon: "🏅", amount: "\(resources.gold)")
            ResourceItem(icon: "🥈", amount: "\(resources.silver)")
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
    var icon: String
    var amount: String

    var body: some View {
        HStack(spacing: 3) {
            Text(icon)
                .font(.system(size: 14))
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
    ContentView()
}
