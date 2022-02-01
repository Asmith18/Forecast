//
//  Day.swift
//  Forecast
//
//  Created by adam smith on 2/1/22.
//

import Foundation
// creating a model object called day to display the weather
class Day {
    // creating all the properties we need to display in our weahter app
    let cityName: String
    let date: String
    let icon: String
    var temp: Double
    let decsription: String
    let htemp: Double
    let ltemp: Double
    //initializing our variables and giving them values of whichever type we declared them in our properties section
    //if the variables value are not correct they will not work and nothing will display.
    init?(dayDictionary: [String: Any], cityName: String){
        guard let temp = dayDictionary["temp"] as? Double,
              let htemp = dayDictionary["max_temp"] as? Double,
              let ltemp = dayDictionary["low_temp"] as? Double,
              let weather = dayDictionary["weather"] as? [String: Any],
              let icon = weather["icon"] as? String,
              let description = weather["description"] as? String,
              let date = dayDictionary["valid_date"] as? String
        else { return nil }
        // setting the variables we initialized to themselvs and giving them a value
        self.date = date
        self.icon = icon
        self.temp = temp
        self.decsription = description
        self.htemp = htemp
        self.ltemp = ltemp
        self.cityName = cityName
    }
}
