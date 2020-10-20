//
//  LocationSearchModel.swift
//  PetesWeather
//
//  Created by Peter Ent on 10/3/20.
//

import SwiftUI
import MapKit

/**
 * The LocationSearchModel does two types of searches: one is done as the user types and produces
 * locations that match what has been entered. Once the user selects an item, another search is
 * done to get the MKMapItem associated with that phrase. If it matches multiple items, only
 * the first one returned is used.
 */
class LocationSearchModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    
    @Published var searchTerms = [String]()
    @Published var isSearching = false
    
    private var completer: MKLocalSearchCompleter = MKLocalSearchCompleter()
    
    // triggers the search-as-you-type
    //
    func searchFor(term: String, in region: MKCoordinateRegion? = nil) {
        completer.delegate = self
        completer.region = MKCoordinateRegion(.world)
        completer.pointOfInterestFilter = MKPointOfInterestFilter.excludingAll
        completer.queryFragment = term
    }
    
    // returns the MKMapItem for the selection from the first search
    //
    func mapItem(for term:String, onComplete: @escaping (MKMapItem) -> Void) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = term
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            if let response = response, let one = response.mapItems.first {
                DispatchQueue.main.async {
                    onComplete(one)
                }
            }
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    func clearResults() {
        searchTerms.removeAll()
        isSearching = false
    }
    
    // MARK: - COMPLETER DELEGATE
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = completer.results.filter { result in
            guard result.title.contains(",") || !result.subtitle.isEmpty else { return false }
            guard !result.subtitle.contains("Nearby") else { return false }
            return true
        }
        self.searchTerms = results.map { $0.title + ($0.subtitle.isEmpty ? "" : ", " + $0.subtitle) }
        self.isSearching = true
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Completer failed with some error: \(error)")
        isSearching = false
    }
}
