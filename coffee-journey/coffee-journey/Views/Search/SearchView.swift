//
//  SearchView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 28.01.26.
//
import Foundation
import SwiftUI


struct SearchView: View {
    @State private var searchTerm: String = ""
    
    var body: some View {
        NavigationStack {
            Group {
                if searchTerm.isEmpty {
                    RecentSearchesView()
                } else {
                    SearchResultsView()
                }
            }
            .navigationTitle("Search")
            .searchable(text: $searchTerm)
        }
    }
}


#Preview {
    SearchView()
}
