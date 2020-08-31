//
//  SearchView.swift
//  Best_Buy_Product_Search
//
//  Created by Spencer Halverson on 8/30/20.
//  Copyright © 2020 Spencer Halverson. All rights reserved.
//

import SwiftUI
import SwiftlySearch

struct SearchView: View {

    @ObservedObject private var viewModel = SearchViewModel()

    private var suggestionsList: some View {
        List {
            if !viewModel.recents.isEmpty {
                SearchTags(
                    title: "Recent",
                    tags: Array(viewModel.recents),
                    color: .blue,
                    onTap: onTagTap(_:),
                    onClear: { self.viewModel.recents.removeAll() })
            }

            SearchTags(
                title: "Trending",
                tags: viewModel.trending,
                color: .green,
                onTap: onTagTap(_:))

            SearchTags(
                title: "Popular",
                tags: viewModel.popular,
                color: .red,
                onTap: onTagTap(_:))
        }
    }

    private var resetButton: some View {
        Button(action: viewModel.reset, label: {
            Text("Start Over").bold()
                .frame(maxWidth: .infinity, maxHeight: 45)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(20)
        })
        .shadow(radius: 1)
    }

    var body: some View {
        Group {
            ZStack {
                if viewModel.searching {
                    ActivityIndicator(label: "Searching", style: .medium, axis: .vertical)
                } else if !viewModel.results.isEmpty {
                    ResultsView(results: viewModel.results)
                } else {
                    suggestionsList
                }

                if !viewModel.results.isEmpty {
                    VStack {
                        Spacer()
                        resetButton
                    }
                }
            }
        }
        .navigationBarSearch(
            $viewModel.keywords,
            placeholder: "Search...",
            hidesSearchBarWhenScrolling: false,
            cancelClicked: viewModel.reset,
            searchClicked: viewModel.search)
    }

    private func onTagTap(_ text: String) {
        viewModel.keywords = text
        viewModel.search()
    }
}

struct SearchTags: View {

    var title: String
    var tags: [String]
    var color: Color
    var onTap: (String) -> Void
    var onClear: (() -> Void)?

    var body: some View {
        Section {
            HStack(alignment: .center) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)

                Spacer()

                if onClear != nil {
                    Text("Clear")
                        .onTapGesture { self.onClear?() }
                }
            }
            .padding(.top, 30)

            ForEach(tags, id: \.self) { tag in
                Button(tag) {
                    self.onTap(tag)
                }
                .font(.body)
                .foregroundColor(self.color)
                .padding(.vertical, 5)
            }
         }
    }
}
