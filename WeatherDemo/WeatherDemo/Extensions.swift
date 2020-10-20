//
//  Extensions.swift
//  PetesWeather
//
//  Created by Peter Ent on 10/4/20.
//

import SwiftUI
import MapKit

//MARK: - VIEW

#if canImport(UIKit)
extension View {
    
    // Makes it easier to dismiss the keyboard from virtually anywhere in the app.
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

//MARK: - COLOR

extension Color {
    
    public static let iconBackground = Color("DuskDawn")
    public static let dayLight = Color("DayLight")
    public static let nightLight = Color("NightLight")
    public static let searchBackground = Color("Cadet")
}

//MARK: - DATE

extension Date {
    
    // extracts the hour from the given date and formats it as "8a" or "3p". It does this
    // using DateFormatter and, because the format returns AM or PM, drops the last character
    // and then lowercases the result.
    
    func formattedHour() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        let result = String(formatter.string(from: self).dropLast())
        return result.lowercased()
    }
}

//MARK: - STRING LOCALIZATION

extension String {
    
    // easy to use quick localization. Just put the key into the Localizable.strings file - per
    // language - and then use the key in the source code. For example:
    //     let title = "main_title".localized()
    // In the Localized.strings file:
    //     "main_title" = "Welcome to the App";
    //
    // This will set title to be "Welcome to App" at runtime.
    //
    // Note: many SwiftUI components will take the key as their argument so you do not
    // always need to use this function.
    
    func localized() -> String {
        NSLocalizedString(self, comment: self)
    }
}
