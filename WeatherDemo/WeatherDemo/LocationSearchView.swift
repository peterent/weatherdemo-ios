//
//  LocationSearchView.swift
//  PetesWeather
//
//  Created by Peter Ent on 10/6/20.
//

import SwiftUI
import MapKit

/**
 * Displays a View with a search input field and a list of results. Selecting an item from the list
 * triggers the AppController to find the weather data for that location. This also shows a search
 * history (if present) which remains visible until the user starts to type. 
 */
struct LocationSearchView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentatinMode
    @EnvironmentObject var appController: AppController
    
    @StateObject private var searchModel = LocationSearchModel()
    
    @State private var searchTerm = ""
    @State private var selectedItem: MKMapItem?
    @State private var showingHistory = true
    
    // Core Data fetch request for the search history items
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SearchHistoryItem.title, ascending: true)],
        animation: .default)
    private var historyItems: FetchedResults<SearchHistoryItem>
    
    struct CurrentLocationButton: View {
        var action: () -> Void
        var body: some View {
            Button(action: self.action) {
                Group {
                    Image(systemName: "location.fill")
                    Text("Use current location")
                }
            }
            .font(.caption)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // Heading with search input field
            HStack {
                Image(systemName: "magnifyingglass")
                
                // as the user types, onChange is called and that trigger the search
                TextField("Search", text: self.$searchTerm, onCommit: {
                    self.hideKeyboard()
                })
                .onChange(of: self.searchTerm) { (value) in
                    self.searchModel.searchFor(term: value)
                    self.showingHistory = false
                }
                CancelSearchButton() {
                    self.searchTerm = ""
                    self.searchModel.clearResults()
                    self.hideKeyboard()
                    self.showingHistory = true
                }
            }
            .padding()
            
            // Subheading area with instructions and current location button
            HStack {
                Text("Swipe down to dismiss")
                    .font(.caption)
                    .padding(.leading, 12)
                Spacer()
                CurrentLocationButton() {
                    self.appController.updateCurrentLocation()
                    self.searchTerm = ""
                    self.searchModel.clearResults()
                    self.hideKeyboard()
                    self.presentatinMode.wrappedValue.dismiss()
                }
                .foregroundColor(.white)
                .padding(.trailing, 12)
            }
            
            // Search History or Search Results
            
            if self.showingHistory && historyItems.count > 0 {
                SearchHistoryView(historyItems: self.historyItems, onDelete: self.deleteItems) { (item) in
                    self.searchTerm = item.title!
                    self.appController.updateCurrentLocation(with: CLLocation(latitude: item.latitude, longitude: item.longitude), title: item.title!)
                    self.presentatinMode.wrappedValue.dismiss()
                }
            } else {
            
                // when the search results are tapped, the selected one triggers onChange to
                // update the model in the appController.
                SearchResultsView(searchModel: self.searchModel, selectedItem: self.$selectedItem)
                    .onChange(of: self.selectedItem) { (newItem) in
                        self.hideKeyboard()
                        if let newItem = newItem {
                            self.searchTerm = newItem.placemark.name!
                            self.appController.updateCurrentLocation(with: newItem)
                            self.addItemToHistory(item: newItem)
                            self.presentatinMode.wrappedValue.dismiss()
                        }
                    }
            }
        }
        .background(Color.searchBackground)
    }
    
    // SEARCH HISTORY ADD AND DELETE
    
    func addItemToHistory(item: MKMapItem) {
        let newItem = SearchHistoryItem(context: viewContext)
        newItem.title = item.placemark.title
        newItem.latitude = item.placemark.coordinate.latitude
        newItem.longitude = item.placemark.coordinate.longitude
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Cannot save history: \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { historyItems[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView()
    }
}
