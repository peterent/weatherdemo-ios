//
//  WeatherDemoApp.swift
//  PetesWeather
//
//  Created by Peter Ent on 10/1/20.
//

import SwiftUI

@main
struct WeatherDemoApp: App {
    @Environment(\.scenePhase) private var scenePhase
    let persistenceController = PersistenceController.shared
    
    @StateObject var appController = AppController()
    
    var isDay: Bool {
        appController.weatherData?.isDay() ?? true
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(appController)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    (isDay ? Color.dayLight : Color.nightLight)
                        .edgesIgnoringSafeArea(.all))
        }
        
        // use onChange to detect when the scenePhase changes and when the app becomes
        // active, thats when we fetch the weatherData. This allows the user to look at
        // the weather in the morning, do other things on the phone, then open it in the
        // afternoon and refreshed weather data will appear.
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
            case .active:
                self.appController.refreshWeatherData()
            default:
                // ignore
                break
            }
        }
    }
}
