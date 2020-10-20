//
//  ContentViewHeader.swift
//  PetesWeather
//
//  Created by Peter Ent on 10/13/20.
//

import SwiftUI

/**
 * The ContentViewHeader is a bar across the top of the ContentView when it shows the
 * ForecastView and displays the ImperialOrMetricButton on one side of the screen
 * and the search button on the other side. The action from the search button is
 * passed back through this View's own action.
 *
 * Note: the positioning of the header is determined by its padding which relies
 * on the horizontal size trait class. In Regular size, the padding is less.
 */
struct ContentViewHeader: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var title: String
    var searchAction: () -> Void
    
    var body: some View {
        HStack {
            ImperialOrMetricButton()
            Spacer()
            Text(title).font(.headline)
            Spacer()
            SearchButton() {
                self.searchAction()
            }
        }
        .background(Color.clear)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .padding([.leading, .trailing], 20)
    }
}

struct ContentViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewHeader(title: "Test Place") {
            print("Button tapped")
        }
    }
}
