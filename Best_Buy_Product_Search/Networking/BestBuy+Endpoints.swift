//
//  BestBuy+Endpoints.swift
//  Best_Buy_Product_Search
//
//  Created by Spencer Halverson on 8/30/20.
//  Copyright © 2020 Spencer Halverson. All rights reserved.
//

import Foundation
import Combine

extension BestBuy {

    func search(_ keywords: String) -> AnyPublisher<SearchResponse, Error> {

        /*Initialize query parameters with properties to be returned in search results*/
        let parameters: [String: String] = [
            "show": "sku,name,salePrice,image,shortDescription,longDescription,manufacturer,url,features.feature"
        ]

        /*Add each search keyword to the path search parameters*/
        let searchPath = keywords
            .components(separatedBy: " ")
            .map({ keyword in "search=\(keyword)" })
            .joined(separator: "&")

        return run(.get, "/v1/products(\(searchPath))", params: parameters)
    }
}
