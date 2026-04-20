//
//  NewsModel.swift
//  StockGame
//
//  Created by Fadil Himawan on 20/04/26.
//

import SwiftUI

struct NewsItem: Identifiable {
    let id = UUID()
    var title: String
    var date: Date
    var description: String
    var effects: [NewsEffect]
}
