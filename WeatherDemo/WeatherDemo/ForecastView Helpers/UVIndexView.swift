//
//  UVIndexView.swift
//  PetesWeather
//
//  Created by Peter Ent on 10/11/20.
//

import SwiftUI

/**
 * Displays a UV (ultraviolet) index on a color-coded scale. The UV index is supposed
 * to be a value between 0 and 10, but in some regions or on some days the value can be
 * beyond 10, so this View caps it at 10 to avoid the indicator appearing off of the scale.
 */
struct UVIndexView: View {
    var uvi: Double?
    var isDay: Bool
    var width: CGFloat = 100
    
    private let linear = LinearGradient(
        gradient: Gradient(colors: [.green, .yellow, .red, .purple]),
        startPoint: .leading,
        endPoint: .trailing)
    
    private func uviOffset() -> CGFloat {
        guard let uvi = isDay ? uvi : 0 else { return 0 }
        let percent = CGFloat(min(uvi, 10) / 10.0)
        return (self.width * percent) - CGFloat(self.width / 2.0)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(self.linear)
                .frame(width: self.width, height: 6)
            Circle()
                .frame(width: 10, height: 10)
                .foregroundColor(.white)
                .offset(x: self.uviOffset(), y: 0)
        }
    }
}

struct UVIndexView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            UVIndexView(uvi: 8, isDay: false)
        }
        .padding()
        .background(Color.black)
    }
}
