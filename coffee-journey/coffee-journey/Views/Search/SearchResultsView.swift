//
//  SearchResults.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 28.01.26.
//
import Foundation
import SwiftUI
import SwiftData


struct SearchResultsView<T: SearchableModel, R: ResultRowRenderer>: View where R.Model == T {
    let searchTerm: String
    let renderer: R

    @Query private var items: [T]

    init(searchTerm: String, renderer: R) {
        self.searchTerm = searchTerm
        self.renderer = renderer
        if let predicate = T.search(for: searchTerm) {
            _items = Query(filter: predicate)
        } else {
            _items = Query()
        }
    }

    var body: some View {
        List(items) { item in
            renderer.row(for: item)
        }
    }
}


#Preview {
    SearchResultsView(searchTerm: "Test", renderer: CoffeeRowRenderer())
}
