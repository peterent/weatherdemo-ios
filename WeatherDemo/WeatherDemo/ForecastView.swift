//
//  ForecastView.swift
//  PetesWeather
//
//  Created by Peter Ent on 10/2/20.
//

import SwiftUI

/**
 * ForecastView is the primary display of this app. It uses help Views (such as
 * UVIndexView) to display a location's current weather and an 8 day forecast.
 *
 * The horizontal size trait class is used to determine if the layout is vertical
 * (iPhone held in portrait orientation) or horizontal (iPhone held in landscape
 * orientation or any iPad).
 */
struct ForecastView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var appController: AppController
    
    var weatherData: WeatherData
    
    let forecastColumns = [ GridItem(.flexible(minimum: 80)) ]
    
    // based on the device size traits, either a primary vertical or horizontal layout
    var body: some View {
        if horizontalSizeClass == .compact {
            return AnyView(verticalLayout)
        } else {
            return AnyView(horizontalLayout)
        }
    }
    
    var eightDayForecast: some View {
        Group {
            if let dailyWeather = weatherData.daily {
                LazyVGrid(columns: forecastColumns) {
                    ForEach(0..<dailyWeather.count, id: \.self) { index in
                        ForecastRowView(dailyWeather: dailyWeather[index])
                            .padding([.top, .bottom], 5)
                    }
                }
            } else {
                EmptyView()
            }
        }
    }
    
    // layout of landscape iPhone or iPads
    var horizontalLayout: some View {
        GeometryReader { proxy in
            HStack(alignment: .center) {
                    
                if weatherData.current != nil {
                    CurrentConditionsView(weatherData: weatherData, proxy: proxy)
                }
                    
                ScrollView(.vertical, showsIndicators: false) {
                    
                    if let hourlyData = appController.hourlyData {
                        TabView {
                            HourlyTemperatureView(hourlyData: hourlyData)
                            HourlyRainView(hourlyData: hourlyData)
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .frame(height: 200)
                    }
                    
                    eightDayForecast
                }
                .padding([.leading, .trailing], 10)
            }
            
            .frame(width: proxy.size.width)
        }
    }
    
    // layout for iPhone in portrait orientation
    var verticalLayout: some View {
        GeometryReader { proxy in
            VStack(alignment: .center) {
                                
                Spacer()
                
                ScrollView(.vertical, showsIndicators: false) {
                    if weatherData.current != nil {
                        CurrentConditionsView(weatherData: weatherData, proxy: proxy)
                    }
                    
                    if let hourlyData = appController.hourlyData {
                        TabView {
                            HourlyTemperatureView(hourlyData: hourlyData)
                            HourlyRainView(hourlyData: hourlyData)
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .frame(width: proxy.size.width * 0.85, height: 200)
                    }
                                    
                    eightDayForecast
                        .padding([.leading, .trailing], 10)
                }
            }
        }
    }
}

// MARK: - PREVIEWS

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView(weatherData: WeatherData())
    }
}
