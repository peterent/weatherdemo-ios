//
//  ImperialOrMetricButton.swift
//  PetesWeather
//
//  Created by Peter Ent on 10/13/20.
//

import SwiftUI

/**
 * Displays a [F°] or [C°] button that changes the units used in the weather
 * display from imperial to metric.
 */
struct ImperialOrMetricButton: View {
    @EnvironmentObject var appController: AppController
    
    @State private var imperial = true
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.imperial.toggle()
                self.appController.changeUnits(isImperial: self.imperial)
            }
        }) {
            HStack {
                Image(systemName: "thermometer")
                Text( self.imperial ? "°F" : "°C" )
            }
            .padding(4)
        }
        .background(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.white, lineWidth: 1)
        )
    }
}

struct ImperialOrMetricButton_Previews: PreviewProvider {
    static var previews: some View {
        ImperialOrMetricButton()
            .environmentObject(AppController())
    }
}
