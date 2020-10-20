//
//  DayOfWeekView.swift
//  PetesWeather
//
//  Created by Peter Ent on 10/11/20.
//

import SwiftUI

/**
 * Shows the day of the week (eg, "Mon") for any date given as seconds.
 */
struct DayOfWeekView: View {
    var dt: Double?
    @State private var dayOfWeek = ""
    
    init(dt: Double?) {
        self.dt = dt
        if let dt = dt {
            let date = Date(timeIntervalSince1970: dt)
            let cal = Calendar.current
            let dayOfWeek = cal.component(.weekday, from: date)
            self._dayOfWeek = State(initialValue: cal.shortWeekdaySymbols[dayOfWeek-1])
        }
    }
    
    var body: some View {
        Text(self.dayOfWeek)
            .font(.system(.subheadline, design: .monospaced))
    }
}

struct DayOfWeekView_Previews: PreviewProvider {
    static var previews: some View {
        DayOfWeekView(dt: Date().timeIntervalSince1970)
    }
}
