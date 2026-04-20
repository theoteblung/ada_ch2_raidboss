//
//  Item.swift
//  StockGame
//
//  Created by Fadil Himawan on 20/04/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
