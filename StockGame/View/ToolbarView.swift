//
//  HeaderView.swift
//  StockGame
//
//  Created by Fadil Himawan on 21/04/26.
//

import SwiftUI

struct ToolbarView: ViewModifier {
    let gameTime: GameTime
    let resources: GameResources
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    VStack(alignment: .leading) {
                        Text("Raid Boss")
                            .font(.title)
                        
                        TimelineView(.periodic(from: .now, by: 1)) { context in
                            let currentGameDate = gameTime.currentDate(at: context.date)
                            
                            HStack(spacing: 4) {
                                Text(gameTime.formattedDate(from: currentGameDate))
                                Text("·")
                                Text(gameTime.formattedTime(from: currentGameDate))
                            }
                        }
                    }
                    .frame(width: 120, alignment: .leading)
                    
                }
                .sharedBackgroundVisibility(.hidden)
                
                ToolbarItem(placement: .topBarTrailing) {
                    ResourceBar(resources: resources)
                }
                .sharedBackgroundVisibility(.hidden)
            }
    }
}

extension View {
    func toolbarView(gameTime: GameTime, resources: GameResources) -> some View {
        modifier(ToolbarView(gameTime: gameTime, resources: resources))
    }
}

#Preview {
    let gameTime = GameTime()
    let resources = GameResources()
    
    NavigationStack {
        Text("Hello, World!")
    }
        .toolbarView(gameTime: gameTime, resources: resources)
}
