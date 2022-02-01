//
//  NewtworkController.swift
//  Forecast
//
//  Created by adam smith on 2/1/22.
//

import Foundation

class NetworkController {
    // setting our api url to the value of baseURLString
    private static let baseURLString = "https://api.weatherbit.io/v2.0"
    // creating a func called fetchDays so we can call this function lating in the project to make everything come together and work :)
    static func fetchDays(completion: @escaping ([Day]?) -> Void) {
        // creating a variable called baseURL and giving it a value URL and unwrapping it and if its false it will print "unable to create base url"
        guard var baseURL = URL(string: baseURLString) else {
            print("unable to create base url from: \(baseURLString)")
            completion(nil)
            return
        }
        // adding a pathcomponent to our base URL called forcast and daily which are the contents of the url that we are creating.
        baseURL.appendPathComponent("forecast")
        baseURL.appendPathComponent("daily")
        // creating a variable and assiging it to URLComponents and setting the url to baseURL
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        // creating a varible for every variable we created postman and setting them to their proper string value which is found in postman aswell,
        let keyQuery = URLQueryItem(name: "key", value: "7afce02ff70f4e0a9de22cdb5c3bdf22")
        let postalQuery = URLQueryItem(name: "postal_code", value: "55328")
        let countryQuery = URLQueryItem(name: "country", value: "US")
        let unitsQuery = URLQueryItem(name: "units", value: "I")
        //using .syntax we are calling urlComponents.queryitems and assiging it to the variables we just created above :)
        urlComponents?.queryItems = [keyQuery, postalQuery, unitsQuery, countryQuery]
        // unwrapping our final url and giving it a value of our urlComponents and using .urland if its false it will print a error message.
        guard let finalURL = urlComponents?.url else {
            print("unable to create final URL from: \(urlComponents?.description)")
            completion(nil)
            return
        }
        // using .syntax we are calling urlsession and using datatask with a value of final url which we declared above
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            // if we get an error it will print error and we know this line of code doesnt work.
            if let error = error {
                print(error)
                completion(nil)
            }
            // unwrapping data and giving it a value of data so we can call it later on in this scope
            // if data doesn not equal data then we are printing an error message
            guard let data = data else {
                print("no data was found")
                completion(nil)
                return
            }
            do {
                // using an if let statement to declare a variable called topleveldictianary and using the jsonserialization and giving it the value of data we declared earlier. were typecasting it as a [String: Any]
                if let topLevelDictionary = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] {
                    // using a guard statement and declaring variables using the names of thge top level of our api and type casting them as a String
                    // declaring our data as "data" and typecasting as [[String: Any]] and we are doing this because data is the vary top of our api
                    guard let cityName = topLevelDictionary["city_name"] as? String,
                            let dataArray = topLevelDictionary["data"] as? [[String: Any]]
                    else {
                        print("unable to decode data")
                        completion(nil)
                        return
                    }
                    // declaring a variable named tampArray and setting it to of type Day array = empty array
                    var tempArray: [Day] = []
                    // using a for in loop to declare data in the data array and declaring day to the value of our model with the initializers of our data and city name which are on the top level of our api.
                    for data in dataArray {
                        if let day = Day(dayDictionary: data, cityName: cityName) {
                            // adding day that we declared about to temparrray.
                            tempArray.append(day)
                        } else {
                            // this print sattement will run when day isnt bveing decoded in our data
                            print("failed top decode day: \(data)")
                        }
                    }
                    completion(tempArray)
                }
                // this line of code will run when everything else is working but we are still gettting and error so it will print error and we will know that our code reaches this point
            } catch let error {
                print(error)
                completion(nil)
            }
        }.resume()
    }
}
