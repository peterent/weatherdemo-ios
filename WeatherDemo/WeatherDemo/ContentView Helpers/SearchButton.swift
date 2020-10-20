//
//  SearchButton.swift
//  PetesWeather
//
//  Created by Peter Ent on 10/13/20.
//

import SwiftUI

/**
 * Displays a search button as a large magnifying glass.
 */
struct SearchButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: { self.action() }, label: {
            Image(systemName: "magnifyingglass")
        })
        .font(.title)
    }
}

struct SearchButton_Previews: PreviewProvider {
    static var previews: some View {
        SearchButton() {
            print("SearchButton tapped")
        }
    }
}
