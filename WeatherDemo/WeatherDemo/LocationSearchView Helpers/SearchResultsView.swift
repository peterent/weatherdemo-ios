//
//  SearchResultsView.swift
//  PetesWeather
//
//  Created by Peter Ent on 10/3/20.
//

import SwiftUI
import MapKit

/**
 * Displays the results of doing a location search (eg, "Trento"). If no
 * results are present, its either because the search wasn't started (the
 * searchModel.isSearching is false) or nothing was found.
 */
struct SearchResultsView: View {
    @ObservedObject var searchModel: LocationSearchModel
    @Binding var selectedItem: MKMapItem?
    
    var body: some View {
        VStack {
            Divider()
            
            if self.searchModel.searchTerms.count == 0 {
                if self.searchModel.isSearching {
                    Text("No items found")
                        .font(.title).padding()
                } else {
                    Text("Search for a city or place above")
                        .font(.body).padding()
                }
            }
            
            List(searchModel.searchTerms, id: \.self) { term in
                VStack(alignment: .leading) {
                    Text(term)
                        .font(.headline)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    self.searchModel.mapItem(for: term) { mapItem in
                        self.selectedItem = mapItem
                    }
                }
            }
        }
    }
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView(searchModel: LocationSearchModel(), selectedItem: .constant(nil))
    }
}
