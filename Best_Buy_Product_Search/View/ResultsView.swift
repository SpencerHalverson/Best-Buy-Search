//
//  ResultsView.swift
//  Best_Buy_Product_Search
//
//  Created by Spencer Halverson on 8/30/20.
//  Copyright © 2020 Spencer Halverson. All rights reserved.
//

import SwiftUI

struct ResultsView: View {

    var results: [Product]
    
    var body: some View {
        List(results, id: \.sku) { item in
            NavigationLink(
                destination: DetailView(product: item),
                label: { ProductRow(item: item) }
            )
        }
    }
}

struct ProductRow: View {

    var item: Product

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            SquareShadowView(size: 80, content: URLImage(url: item.image))

            VStack(alignment: .leading, spacing: 5) {
                Text(item.name)
                    .font(.headline)
                    .fontWeight(.heavy)

                Text("Sale Price: \(item.salePrice.price)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)

                Text("Sku: \(item.sku.description)")
                    .foregroundColor(.gray)
                    .font(.caption)


                Text(item.shortDescription)
                    .foregroundColor(.gray)
                    .font(.caption)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 10)
    }
}
