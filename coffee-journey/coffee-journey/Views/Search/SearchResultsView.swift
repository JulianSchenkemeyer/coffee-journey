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

    /// A split view's sidebar drives its detail column through the list selection, so results
    /// shown there have to feed the same binding as the unsearched list.
    @Binding var selection: Router.Route?

    @Query private var items: [T]

    init(searchTerm: String, renderer: R, selection: Binding<Router.Route?>) {
        self.searchTerm = searchTerm
        self.renderer = renderer
        self._selection = selection
        if let predicate = T.search(for: searchTerm) {
            _items = Query(filter: predicate)
        } else {
            _items = Query()
        }
    }

    var body: some View {
        List(items, selection: $selection) { item in
            renderer.row(for: item)
        }
//        .listStyle(.plain)
    }
}


#Preview {
    SearchResultsView(searchTerm: "Test", renderer: CoffeeRowRenderer(), selection: .constant(nil))
}
