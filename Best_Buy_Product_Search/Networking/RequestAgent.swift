//  RequestAgent.swift
//  Best_Buy_Product_Search
//
//  Created by Spencer Halverson on 8/30/20.
//  Copyright © 2020 Spencer Halverson. All rights reserved.
//

import Foundation
import Combine

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case update = "UPDATE"
    case delete = "DELETE"
    case patch = "PATCH"
}

/*This class is just meant to make building a URL Request simpler with provided defaults*/
struct RequestAgent {

    var method: HTTPMethod = .get
    var host: String = ""
    var path: String = ""
    var headers: [String: String] = [:]

    func makeRequest(_ parameters: [String: String]? = nil, body: Data? = nil) -> URLRequest {
        var components = URLComponents(string: host + path)
        components?.queryItems = parameters?.map({
            URLQueryItem(name: $0.key, value: $0.value)
        })

        guard let url = components?.url else { fatalError("INVALID URL SUPPLIED") }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body

        return request
    }

    /// Generates a url request that is a multi-part form upload
    //  swiftlint:disable line_length
    //  Without the line length disable the opener isn't formed correctly
    func multipartFormRequest(_ data: Data,
                              name: String,
                              fileName: String,
                              mimeType: String,
                              additionalHeaders: [String: String] = [:]) -> URLRequest {

        let boundary = UUID().uuidString

        let opener = "--\(boundary)\r\nContent-dispostion: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\nContent-Type: \(mimeType)\r\n\r\n"
            .data(using: .utf8, allowLossyConversion: false)

        let closing = "\r\n--\(boundary)--\r\n"
            .data(using: .utf8, allowLossyConversion: false)

        let formData = opener! + data + closing!

        var request = makeRequest(body: formData)
        request.setValue("multipart/form-data; boundary=" + boundary, forHTTPHeaderField: "Content-Type")
        request.setValue(formData.count.description, forHTTPHeaderField: "Content-Length")

        for header in additionalHeaders {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }

        return request
    }

    /// Send request with a specified return type
    /// - Parameters:
    ///   - parameters: the url query parameters
    ///   - body: the body of the request that will be json encoded
    ///   - return: A data task to attach subscribers
    func send<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap({ result in

                guard let response = result.response as? HTTPURLResponse else {
                    throw ErrorMessage(display_message: "Invalid Request")
                }

                guard response.statusCode <= 299 && response.statusCode >= 200 else {
                    do {
                        throw try JSONDecoder().decode(ErrorMessage.self, from: result.data)
                    } catch {
                        throw ErrorMessage(display_message: "Status Code \(response.statusCode)")
                    }
                }

                if let data = result.data as? T {
                    return data
                } else {

                    let json = try? JSONSerialization.jsonObject(with: result.data, options: .allowFragments) as? [String: Any]
                    print("\n\nJSON RESPONSE: ", json ?? [:])

                    return try JSONDecoder().decode(T.self, from: result.data)
                }
            })
            .print("\n<---\(request.httpMethod ?? "INVALID METHOD") REQUEST \(request.url?.absoluteString ?? "INVALID URL")", to: nil)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

///This is to the structure to decode when request results in api error
//swiftlint:disable identifier_name
struct ErrorMessage: Decodable, Identifiable, LocalizedError {
    var id: UUID = UUID()
    var error_type: String = ""
    var error_code: String = ""
    var error_message: String = ""
    var display_message: String = ""
    var errorDescription: String? { error_message }
    var localizedDescription: String { display_message }
}
