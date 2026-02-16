//
//  SearchView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 28.01.26.
//
import Foundation
import SwiftUI


struct SearchView: View {
    enum SearchType: String, Hashable, CaseIterable, Identifiable {
        case coffee = "Coffee"
        case equiment = "Equipment"
        
        var id: String { rawValue }
    }
    
    @State private var searchTerm: String = ""
    @State private var selectedType = SearchType.coffee
    
    var body: some View {
        RouterView {
            VStack(spacing: 24) {
                Picker("Type", selection: $selectedType) {
                    ForEach(SearchType.allCases, id: \.self) { type in
                        Text(type.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 48)
                
                if searchTerm.isEmpty {
                    RecentSearchesView()
                } else {
                    switch selectedType {
                    case .coffee:
                        SearchResultsView(searchTerm: searchTerm, renderer: CoffeeRowRenderer())
                    case .equiment:
                        SearchResultsView(searchTerm: searchTerm, renderer: EquipmentRowRenderer())
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .navigationTitle("Search")
            .searchable(text: $searchTerm)
        }
    }
    
    
}


#Preview {
    PreviewUseCaseEnvironment {
        SearchView()
    }
}

