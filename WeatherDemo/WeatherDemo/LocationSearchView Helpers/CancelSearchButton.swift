//
//  CancelSearchButton.swift
//  PetesWeather
//
//  Created by Peter Ent on 10/6/20.
//

import SwiftUI

/**
 * A simple button with an (x) image. Use as:
 *
 * CancelSearchButton(action: { in
 *    // do something
 * })
 *
 * or more conveniently:
 *
 * CancelSearchButton() {
 *     // do something
 * }
 *
 * since it has a closure as its last (and only) property.
 */
struct CancelSearchButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            self.action()
        }, label: {
            Image(systemName: "xmark.circle.fill")
                .font(.body)
                .foregroundColor(.black)
        })
    }
}

struct CancelSearchButton_Previews: PreviewProvider {
    static var previews: some View {
        CancelSearchButton() { /* ignored */ }
    }
}
