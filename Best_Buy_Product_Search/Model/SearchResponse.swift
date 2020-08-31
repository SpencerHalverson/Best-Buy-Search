//
//  SearchResponse.swift
//  Best_Buy_Product_Search
//
//  Created by Spencer Halverson on 8/30/20.
//  Copyright © 2020 Spencer Halverson. All rights reserved.
//

import Foundation

struct SearchResponse: Decodable {
    let total: Int?
    let currentPage: Int?
    let totalPages: Int?
    let products: [Product]
}

struct Product: Decodable {
    let sku: Int
    let name: String
    let salePrice: Double
    let image: String
    let longDescription: String
    let shortDescription: String
    let features: [Feature]
    let manufacturer: String
    let url: String
}

struct Feature: Decodable {
    let id = UUID().uuidString
    let feature: String
}

extension Double {

    var price: String {
        "$\(String(format: "%.02f", self))"
    }
}
