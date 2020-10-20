//
//  CastCapsule.swift
//  PetesWeather
//
//  Created by Peter Ent on 10/14/20.
//

import SwiftUI

/**
 * Displays an elongated, colorful, capsule to denote temperate ranges. For example
 * if the given hiTemp is 88 and the loTemp is 55, the colors inside the capsule
 * shape will be a linear gradient from red to green and include orange and yellow.
 */
struct TempRangeView: View {
    var hiTemp: Double
    var loTemp: Double
    var isMetric: Bool
    
    // maps temperature ranges to colors. Highest temp is Black, Lowest
    // temp is White. Purples, reds, oranges, yellows, greens, blues, grays
    // in between.
    private let rangeMap = [
        (110..<212) : Color(red: 0, green: 0, blue: 0),
        (105..<110) : Color(red: 127/255.0, green: 0, blue: 166/255.0),
        (100..<105) : Color(red: 180/255.0, green: 2/255.0, blue: 235/255.0),
        (95..<100)  : Color(red: 196/255.0, green: 2/255.0, blue: 255/255.0),
        (90..<95)   : Color(red: 247/255.0, green: 2/255.0, blue: 255/255.0),
        (85..<90)   : Color(red: 255/255.0, green: 0, blue: 153/255.0),
        (80..<85)   : Color(red: 255/255.0, green: 0, blue: 0),
        (75..<80)   : Color(red: 255/255.0, green: 102/255.0, blue: 0),
        (70..<75)   : Color(red: 255/255.0, green: 149/255.0, blue: 0),
        (65..<70)   : Color(red: 255/255.0, green: 179/255.0, blue: 0),
        (60..<65)   : Color(red: 255/255.0, green: 208/255.0, blue: 0),
        (55..<60)   : Color(red: 255/255.0, green: 238/255.0, blue: 0),
        (50..<55)   : Color(red: 255/255.0, green: 255/255.0, blue: 0),
        (45..<50)   : Color(red: 217/255.0, green: 255/255.0, blue: 0),
        (40..<45)   : Color(red: 115/255.0, green: 255/255.0, blue: 0),
        (35..<40)   : Color(red: 0, green: 255/255.0, blue: 13/255.0),
        (30..<35)   : Color(red: 0, green: 255/255.0, blue: 179/255.0),
        (25..<30)   : Color(red: 67/255.0, green: 158/255.0, blue: 255/255.0),
        (20..<25)   : Color(red: 0, green: 102/255.0, blue: 255/255.0),
        (15..<20)   : Color(red: 134/255.0, green: 190/255.0, blue: 249/255.0),
        (10..<15)   : Color(red: 189/255.0, green: 208/255.0, blue: 244/255.0),
        (5..<10)    : Color(red: 216/255.0, green: 216/255.0, blue: 216/255.0),
        (0..<5)     : Color(red: 239/255.0, green: 239/255.0, blue: 239/255.0),
        (-100..<0)  : Color(red: 1, green: 1, blue: 1)
    ]
    
    private var linear = LinearGradient(
        gradient: Gradient(colors: [.yellow, .green, .blue, .purple]),
        startPoint: .leading,
        endPoint: .trailing)
    
    private func determineColors(hiTemp: Double, loTemp: Double) -> [Color] {
        var result = [Color]()
                
        // since the ranges array are temps in Fahrenheit, convert metric (Celsius)
        // into imperial
        let hiTemp = Int(isMetric ? (hiTemp * 9.0/5.0) + 32 : hiTemp)
        let loTemp = Int(isMetric ? (loTemp * 9.0/5.0) + 32 : loTemp)
        let intRange = (loTemp...hiTemp)
        
        // since keys does not return an ordered list, they need to be sorted
        // before they can be used since order is critical to displaying the
        // colors correctly.
        let ranges = rangeMap.keys.sorted(by: { $0.lowerBound > $1.lowerBound })
            
        ranges.forEach { (range) in
            if intRange.overlaps(range), let color = rangeMap[range] {
                result.append(color)
            }
        }
        
        return result
    }
    
    init(hiTemp: Double, loTemp: Double, isMetric: Bool) {
        self.hiTemp = hiTemp
        self.loTemp = loTemp
        self.isMetric = isMetric
        linear = LinearGradient(
            gradient: Gradient(colors: determineColors(hiTemp: hiTemp, loTemp: loTemp)),
            startPoint: .leading,
            endPoint: .trailing)
    }
    
    var body: some View {
        Capsule()
            .fill(self.linear)
            .frame(height: 10)
    }
}

struct TempRangeView_Previews: PreviewProvider {
    static var previews: some View {
        TempRangeView(hiTemp: 39, loTemp: 12, isMetric: false)
            .padding(30)
    }
}
