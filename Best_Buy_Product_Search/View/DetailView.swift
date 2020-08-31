//
//  DetailView.swift
//  Best_Buy_Product_Search
//
//  Created by Spencer Halverson on 8/30/20.
//  Copyright © 2020 Spencer Halverson. All rights reserved.
//

import SwiftUI

struct DetailView: View {

    @Environment(\.presentationMode) var presented

    var product: Product

    private var productInformation: some View {
        List {

            VStack(alignment: .leading) {
                URLImage(url: self.product.image)
                    .aspectRatio(1, contentMode: .fill)
                    .clipped()
                    .frame(height: 400)
                    .padding(.horizontal, -20)

                Text(product.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .padding(.trailing, 10)
                    .lineLimit(nil)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Manufacturer: \(product.manufacturer)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 10)

                    Text("Sku: \(product.sku.description)")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text("Sale Price: \(product.salePrice.price)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
            }

            Header(text: "Product Details")

            Text(product.longDescription)
                .font(.body)
                .fontWeight(.light)
                .padding(.vertical)

            Header(text: "Product Features")

            Text(product.features.map({ $0.feature }).joined(separator: "\n\n"))
                .font(.body)
                .fontWeight(.light)
                .padding(.vertical)
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
    }

    private var purchaseButton: some View {
        ZStack {
            Color.white
                .shadow(color: .lightGray, radius: 2, x: 0, y: -2)
                .frame(height: 85)

            Button(action: didTapPurchase, label: {
                Text("Purchase Product").bold()
                    .frame(maxWidth: .infinity, maxHeight: 45)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(20)
            })
        }
    }

    private var backButton: some View {
        Button(
            action: { self.presented.wrappedValue.dismiss() },
            label: {
                Image(systemName: "chevron.left.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.blue)                    
        })
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                productInformation
                purchaseButton
            }

            backButton
                .position(x: 30, y: 30)
        }
        .navigationBarTitle("Product Detail", displayMode: .inline)
    }

    private func didTapPurchase() {
        guard
            let productUrl = URL(string: product.url),
            UIApplication.shared.canOpenURL(productUrl) else {
                print("INVALID PRODUCT URL")
                return
        }

        UIApplication.shared.open(productUrl, options: [:], completionHandler: { success in
            print("DID OPEN PRODUCT URL: \(success)")
        })
    }
}

struct Header: View {

    let text: String

    var body: some View {
        Text(text)
            .font(.headline)
            .bold()
            .padding(.top, 25)
    }
}
