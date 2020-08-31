//
//  UtilityViews.swift
//  Best_Buy_Product_Search
//
//  Created by Spencer Halverson on 8/30/20.
//  Copyright © 2020 Spencer Halverson. All rights reserved.
//

import SwiftUI

struct SquareShadowView<Content: View>: View {

    var size: CGFloat
    var content: Content

    var body: some View {
        ZStack {
            Color.lightGray
            Image(systemName: "photo")

            content
                .aspectRatio(contentMode: .fill)
        }
        .frame(width: size, height: size)
        .cornerRadius(10)
        .shadow(color: .lightGray, radius: 2, x: 1, y: 1)
    }
}

struct URLImage: View {

    @ObservedObject private var loader = ImageLoader()

    init(url: String?) {
        guard let url = url else { return }
        loader.load(url)
    }

    var body: some View {
        loader.downloadedImage.map({
            Image(uiImage: $0)
                .renderingMode(.original)
                .resizable()
        })
    }
}

extension Color {
    public static var darkGray: Color {
        Color(red: 0.367, green: 0.367, blue: 0.375)
    }

    public static var lightGray: Color {
        Color(red: 0.939, green: 0.939, blue: 0.939)
    }
}
