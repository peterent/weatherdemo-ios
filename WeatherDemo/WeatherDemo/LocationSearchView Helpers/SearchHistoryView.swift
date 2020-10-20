//
//  SearchHistoryView.swift
//  PetesWeather
//
//  Created by Peter Ent on 10/19/20.
//

import SwiftUI

/**
 * Displays the given list of SearchHistoryItems as a pickable list. Can also swipe
 * to delete one.
 */
struct SearchHistoryView: View {
    var historyItems: FetchedResults<SearchHistoryItem>
    var onDelete: (IndexSet) -> Void
    var onSelection: (SearchHistoryItem) -> Void
    
    var body: some View {
        List {
            Text("Previous Searches")
                .font(.headline)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding()
            ForEach(historyItems) { item in
                Button(item.title!) {
                    self.onSelection(item)
                }
                .foregroundColor(.black)
            }
            .onDelete(perform: self.onDelete)
        }
    }
}
