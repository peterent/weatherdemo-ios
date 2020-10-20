//
//  ForecastRowView.swift
//  PetesWeather
//
//  Created by Peter Ent on 10/11/20.
//

import SwiftUI

/**
 * Displays a single row of information from a DailyWeather forecast.
 */
struct ForecastRowView: View {
    @EnvironmentObject var appController: AppController
    var dailyWeather: WeatherData.DailyWeather
    
    // the temperature "gauge" is the TempRangeView with the hi
    // and lo values above and below it.
    var temperatureGauge: some View {
        VStack(alignment: .center, spacing: 4) {
            HStack {
                Text(dailyWeather.daysHi()).font(.caption)
                Spacer()
            }
            TempRangeView(
                hiTemp: dailyWeather.temp?.max ?? 100,
                loTemp: dailyWeather.temp?.min ?? 0,
                isMetric: appController.isMetric)
            HStack {
                Spacer()
                Text(dailyWeather.daysLo()).font(.caption)
            }
        }
        .frame(width: 100)
    }
    
    var body: some View {
        HStack {
            DayOfWeekView(dt: dailyWeather.dt)
                .padding(.top, 4)
            
            Rectangle().frame(width: 1).foregroundColor(.white)
            
            if let image = dailyWeather.image() {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 32, height: 32)
            }
            Text(dailyWeather.currentCondition())
                .font(.subheadline)
                .padding([.leading, .trailing], 4)
                .layoutPriority(1)
            Spacer()
            
            temperatureGauge
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white, lineWidth: 1)
                .background(Color.white.opacity(0.2))
        )
    }
}

struct ForecastRowView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastRowView(dailyWeather: WeatherData.DailyWeather())
    }
}
