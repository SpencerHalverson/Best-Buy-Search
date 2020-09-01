//
//  ContentView.swift
//  Best_Buy_Product_Search
//
//  Created by Spencer Halverson on 8/30/20.
//  Copyright © 2020 Spencer Halverson. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            SearchView()
                .navigationBarTitle("Search", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension UINavigationController {

    override open func viewDidLoad() {
        super.viewDidLoad()

        let standardAppearance = UINavigationBarAppearance()

        standardAppearance.backgroundColor = .white
        standardAppearance.shadowColor = .lightGray
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.shadowImage = nil
        standardAppearance.shadowColor = .clear

        navigationBar.standardAppearance = standardAppearance

        UITableView.appearance().backgroundColor = .white
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
}
