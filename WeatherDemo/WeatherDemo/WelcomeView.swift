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
    @EnvironmentObject var appController: AppController
    
    var body: some View {
        VStack {
            ZStack {
                Image("LaunchIcon")
                    .resizable()
                    .scaledToFit()
                    .padding()
                Text("Pocket Weather")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            }
            if let errorMessage = appController.errorMessage {
                Text(errorMessage)
                    .font(.title2)
                    .padding(.top)
                    .shadow(color: .white, radius: 10, x: 0, y: 0)
            }
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
