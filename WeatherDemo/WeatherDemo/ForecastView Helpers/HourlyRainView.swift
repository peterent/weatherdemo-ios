//
//  RainView.swift
//  PetesWeather
//
//  Created by Peter Ent on 10/17/20.
//

import SwiftUI

/**
 * Displays a set of bars indicating the amount of predicted rainfall over the next
 * 10 hours. You'll see that specific heights are being used. This makes sure all of
 * the bars' areas a uniform height and the bars themselves are calculated from a
 * known fixed height.
 */
struct HourlyRainView: View {
    var hourlyData: [AppController.HourlyData]
    
    struct RainBar: View {
        var data: AppController.HourlyData
        var body: some View {
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: 124)
                .background(
                    VStack(alignment: .center, spacing: 2) {
                        Spacer()
                        Text(data.rain)
                            .font(.caption)
                        Capsule()
                            .frame(width: 15, height: data.rainHeight == 0 ? 1 : data.rainHeight * 90)
                        Text(data.hour)
                            .font(.caption2)
                    }
                )
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            
            HStack(alignment: .bottom, spacing: 0) {
                Spacer()
                ForEach(hourlyData, id: \.id) { data in
                    RainBar(data: data)
                }
                Spacer()
            }
            
            HStack {
                Text("10-Hour")
                Image(systemName: "umbrella.fill")
            }
            .padding(.top, 8)
            
            Spacer()
        }
    }
}

struct HourlyRainView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyRainView(hourlyData: [AppController.HourlyData]())
            .frame(height: 200)
            .foregroundColor(.blue)
    }
}
