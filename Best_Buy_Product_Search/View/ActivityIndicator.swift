//
//  ActivityIndicator.swift
//  Best_Buy_Product_Search
//
//  Created by Spencer Halverson on 8/30/20.
//  Copyright © 2020 Spencer Halverson. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: View {

    var label: String?

    var style: UIActivityIndicatorView.Style = .medium

    var axis: Axis.Set = .vertical

    var body: some View {
        Group {
            if axis == .vertical {

                VStack {
                    activityComponents
                }

            } else {

                HStack(alignment: .center) {
                    activityComponents
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.easeIn)
        .background(Color.white)
    }

    private var activityComponents: some View {
        Group {
            UIActivityIndicator(style: style)
            label.map({
                Text($0)
                    .font(.caption)
                    .bold()
                    .autocapitalization(.allCharacters)
            })
        }
        .foregroundColor(.gray)
    }
}

private struct UIActivityIndicator: UIViewRepresentable {

    typealias UIViewType = UIActivityIndicatorView

    var style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<UIActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<UIActivityIndicator>) {
        uiView.startAnimating()
    }
}
