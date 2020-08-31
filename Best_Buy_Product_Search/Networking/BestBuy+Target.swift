//
//  BestBuy+Target.swift
//  Best_Buy_Product_Search
//
//  Created by Spencer Halverson on 8/30/20.
//  Copyright © 2020 Spencer Halverson. All rights reserved.
//

import Foundation

struct BestBuy: APITarget {

    static let shared = BestBuy()

    private init() {}

    private let api_key = "7Ob7hGyGMBma1ilGiq7tc2XZ"

    var host: String = "https://api.bestbuy.com"

    var headers: [String: String] {[
        "Accept": "application/json",
        "Content-Type": "application/json",
        ]}

    var parameters: [String: String] {[
        "format": "json",
        "apiKey": api_key
        ]}
}
