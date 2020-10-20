//
//  WindSpeedView.swift
//  PetesWeather
//
//  Created by Peter Ent on 10/11/20.
//

import SwiftUI

/**
 * WindSpeedView displays the given wind speed along with an arrow pointing
 * in the direction of the wind (like a weather vane).
 */
struct WindSpeedView: View {
    @EnvironmentObject var appController: AppController
    
    var speed: Double?
    var direction: Double?
    
    func speedAsString() -> String {
        guard let speed = speed else { return "" }
        return String(format: "%.0f %@", speed, appController.isMetric ? "mps" : "mph")
    }
    
    func directionAsString() -> String {
        guard let direction = direction else { return "" }
        switch direction {
        case 30..<60:
            return "NE".localized()
        case 60..<120:
            return "N".localized()
        case 120..<150:
            return "NW".localized()
        case 150..<210:
            return "W".localized()
        case 210..<240:
            return "SW".localized()
        case 240..<300:
            return "S".localized()
        case 300..<330:
            return "SE".localized()
        default:
            return "E".localized()
        }
    }
    
    var body: some View {
        HStack {
            Text(self.speedAsString())
            Image(systemName: "arrow.right.circle").font(.title)
                .rotationEffect(.degrees(0 - (self.direction ?? 0.0)))
            Text(self.directionAsString())
        }
    }
}

struct WindSpeedView_Previews: PreviewProvider {
    static var previews: some View {
        WindSpeedView(speed: 6, direction: 45)
            .environmentObject(AppController())
    }
}
