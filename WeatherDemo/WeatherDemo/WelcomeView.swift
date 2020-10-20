//
//  WelcomeView.swift
//  PetesWeather
//
//  Created by Peter Ent on 10/16/20.
//

import SwiftUI

/**
 * Simple screen for when the user does not want to allow the current location to be used.
 */
struct WelcomeView: View {
    var body: some View {
        ZStack {
            Image("LaunchIcon")
                .resizable()
                .scaledToFit()
                .padding()
            Text("Welcome")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .background(Color.gray)
            .foregroundColor(.white)
    }
}
