//  APITarget.swift
//  Best_Buy_Product_Search
//
//  Created by Spencer Halverson on 8/30/20.
//  Copyright © 2020 Spencer Halverson. All rights reserved.
//

import Foundation
import Combine

protocol APITarget {
    var host: String { get }
    var headers: [String: String] { get }
    var parameters: [String: String] { get }
}

extension APITarget {


    ///This is a helper method to send a request with a json encoded body
    func run<T: Decodable, B: Encodable>(
        _ method: HTTPMethod,
        _ endpoint: String,
        params: [String: String] = [:],
        body: B? = nil) -> AnyPublisher<T, Error> {

        let data = try? JSONEncoder().encode(body)
        let agent = RequestAgent(method: method, host: host, path: endpoint, headers: headers)
        let combined = params.merging(parameters, uniquingKeysWith: {(_, second ) in second })
        let request = agent.makeRequest(combined, body: data)
        return agent.send(request)
    }

    func run<T: Decodable>(
        _ method: HTTPMethod,
        _ endpoint: String,
        params: [String: String] = [:]) -> AnyPublisher<T, Error> {

        let agent = RequestAgent(method: method, host: host, path: endpoint, headers: headers)
        let combined = params.merging(parameters, uniquingKeysWith: {(_, second ) in second })
        let request = agent.makeRequest(combined)
        return agent.send(request)
    }
}
