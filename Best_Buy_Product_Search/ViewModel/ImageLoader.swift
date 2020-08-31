//
//  ImageLoader.swift
//  Best_Buy_Product_Search
//
//  Created by Spencer Halverson on 8/30/20.
//  Copyright © 2020 Spencer Halverson. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import UIKit

class ImageLoader: ObservableObject {

    private var cacheKey: String?
    private var tasks: Set<AnyCancellable> = []

    @Published var downloadedImage: UIImage? {
        didSet {
            if let key = cacheKey, let image = downloadedImage {
                ImageCache.shared.store(image, for: key)
            }
        }
    }

    func load(_ url: String?) {
        guard
            let urlString = url,
            let url = URL(string: urlString) else { return }

        load(URLRequest(url: url))
    }

    func load(_ request: URLRequest) {
        cacheKey = request.url?.absoluteString
        if let path = cacheKey, let cached = ImageCache.shared.image(for: path) {
            downloadedImage = cached
        } else {
            URLSession.shared
                .dataTaskPublisher(for: request)
                .map({ UIImage(data: $0.data) })
                .replaceError(with: nil)
                .receive(on: RunLoop.main)
                .assign(to: \.downloadedImage, on: self)
                .store(in: &tasks)
        }
    }
}

class ImageCache: NSCache<NSString, UIImage> {

    static var shared = ImageCache()

    func image(for path: String) -> UIImage? {
        return object(forKey: NSString(string: path))
    }

    func store(_ image: UIImage, for path: String) {
        setObject(image, forKey: NSString(string: path))
    }

    func remove(at path: String) {
        removeObject(forKey: path as NSString)
    }

    func reset() {
        removeAllObjects()
    }
}
