//
//  CurrentConditionsView.swift
//  PetesWeather
//
//  Created by Peter Ent on 10/11/20.
//

import SwiftUI

/**
 * Displays the currentWeather portion of a WeatherData struct. This uses
 * several custom Views from the "ForecastView Helpers" folder.
 */
struct CurrentConditionsView: View {
    @EnvironmentObject var appController: AppController
    var weatherData: WeatherData
    var proxy: GeometryProxy
    @State var width: CGFloat? = nil
    
    var currentWeather: WeatherData.CurrentWeather {
        weatherData.current ?? WeatherData.CurrentWeather()
    }
    
    var body: some View {
        HStack {
            Spacer()
                .layoutPriority(1)
            
            TabView {
                
                // Displays the current weather image, temperature and condition
                VStack {
                    HStack {
                        if let image = self.currentWeather.image() {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .scaledToFill()
                        }
                        VStack {
                            Text(self.currentWeather.temperature()).font(.system(size: 48))
                            Text("Feels like") + Text(" ") +  Text(self.currentWeather.feelsLikeAsString())
                        }
                    }
                    Spacer()
                    Text(currentWeather.currentCondition())
                    Spacer()
                }
                .padding()
                
                // Displays addition information
                VStack {
                    Spacer()
                    
                    HStack {
                        VStack(alignment: .center, spacing: 2) {
                            Image(systemName: "sunrise.fill").foregroundColor(.yellow)
                            Text(self.weatherData.sunriseTime()).font(.caption)
                        }
                        Spacer()
                        VStack(alignment: .center, spacing: 2) {
                            Image(systemName: "sunset.fill").foregroundColor(.yellow)
                            Text(self.weatherData.sunsetTime()).font(.caption)
                        }
                    }
                    HStack {
                        Text("Humidity")
                        Spacer()
                        Text(self.currentWeather.humidityAsString())
                    }.padding(4)
                    HStack {
                        Text("Dew Point")
                        Spacer()
                        Text(self.currentWeather.dewPointAsString())
                    }.padding(4)
                    HStack {
                        Text("UV Index")
                        Spacer()
                        UVIndexView(uvi: self.currentWeather.uvi, isDay: self.currentWeather.isDay())
                    }.padding(4)
                    
                    Spacer()
                }
                .padding()
                
                // Displays clouds and wind info
                VStack {
                    Spacer()
                    HStack {
                        Text("Clouds")
                        Spacer()
                        Text(self.currentWeather.cloudinessAsString())
                    }.padding(4)
                    HStack {
                        Text("Visibility")
                        Spacer()
                        Text(self.currentWeather.visibilityAsString())
                    }.padding(4)
                    HStack {
                        Text("Wind")
                        Spacer()
                        WindSpeedView(speed: self.currentWeather.wind_speed, direction: self.currentWeather.wind_deg)
                    }.padding(4)
                    Spacer()
                }
                .padding()
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(width: 256, height: 220)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(self.currentWeather.isDay() ? Color.black.opacity(0.15) : Color.white.opacity(0.15))
            )
            
            Spacer()
                .layoutPriority(1)
        }
    }
}

struct CurrentConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            CurrentConditionsView(weatherData: WeatherData(), proxy: proxy)
            .padding(40)
        }
    }
}
