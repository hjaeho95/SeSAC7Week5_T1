//
//  Shop.swift
//  SeSAC7Week5_T1
//
//  Created by ez on 7/25/25.
//

import Foundation

struct Shop: Decodable {
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    let items: [ShopItem]
}

struct ShopItem: Decodable {
    let title: String
    let link: String
    let image: String
    let lprice: String
    let hprice: String
    let mallName: String
    let productId: String
    let productType: String
    let brand: String
    let maker: String
    let category1: String
    let category2: String
    let category3: String
    let category4: String
}

enum ShopItemSort: String {
    case sim = "sim"
    case date = "date"
    case dsc = "dsc"
    case asc = "asc"
}

enum ShopItemPrefetchConfig: Int {
    case display = 100
    case preloadThreshold = 30
    case maxItemCount = 1000
}
