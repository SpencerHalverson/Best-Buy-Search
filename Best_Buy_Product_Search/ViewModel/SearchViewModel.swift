//
//  SearchViewModel.swift
//  Best_Buy_Product_Search
//
//  Created by Spencer Halverson on 8/30/20.
//  Copyright © 2020 Spencer Halverson. All rights reserved.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {

    @Published var results: [Product] = []
    @Published var keywords: String = ""
    @Published var error: ErrorMessage?
    @Published var searching: Bool = false
    @Published var recents: Set<String> {
        didSet {
            UserDefaults.standard
                .set(Array(recents), forKey: recent_searches)
        }
    }

    /*Placeholder array, but could be fetched from the Best Buy Api*/
    let trending: [String] = [
        "DisplayPort-to-HDMI Adapter",
        "Universal Remote",
        "Polarized Power Cord",
        "4K Ultra TV"
    ]

    /*Placeholder array, but could be fetched from the Best Buy Api*/
    let popular: [String] = [
        "Fiber-Optic Cable",
        "Over-the-Arm Remote Caddy",
        "Stainless Steel Appliances",
        "Outdoor TV Cover"
    ]

    private let recent_searches: String = "recent_searches"
    private var tasks: Set<AnyCancellable> = []

    init() {
        recents = Set(UserDefaults.standard
            .stringArray(forKey: recent_searches) ?? [])
    }

    func search() {
        recents.insert(keywords)

        searching.toggle()
        BestBuy.shared
            .search(keywords)
            .sink(receiveCompletion: { result in
                self.searching.toggle()
                switch result {
                case .failure(let error):
                    self.error = error as? ErrorMessage
                case .finished: break
                }
            }, receiveValue: { response in
                self.results = response.products
            })
            .store(in: &tasks)
    }

    func reset() {
        keywords.removeAll()
        results.removeAll()
    }
}

