//
//  NewtworkController.swift
//  Forecast
//
//  Created by adam smith on 2/1/22.
//

import Foundation

class NetworkController {
    private static let baseURLString = "https://api.weatherbit.io/v2.0"
    
    static func fetchDays(completion: @escaping ([Day]?) -> Void) {
        
        guard var baseURL = URL(string: baseURLString) else {
            print("unable to create base url from: \(baseURLString)")
            completion(nil)
            return
        }
        baseURL.appendPathComponent("forecast")
        baseURL.appendPathComponent("daily")
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        let keyQuery = URLQueryItem(name: "key", value: "7afce02ff70f4e0a9de22cdb5c3bdf22")
        let postalQuery = URLQueryItem(name: "postal_code", value: "55328")
        let countryQuery = URLQueryItem(name: "country", value: "US")
        let unitsQuery = URLQueryItem(name: "units", value: "I")
        
        urlComponents?.queryItems = [keyQuery, postalQuery, unitsQuery, countryQuery]
        
        guard let finalURL = urlComponents?.url else {
            print("unable to create final URL from: \(urlComponents?.description)")
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                print(error)
                completion(nil)
            }
            guard let data = data else {
                print("no data was found")
                completion(nil)
                return
            }
            do {
                if let topLevelDictionary = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] {
                    guard let cityName = topLevelDictionary["city_name"] as? String,
                            let dataArray = topLevelDictionary["data"] as? [[String: Any]]
                    else {
                        print("unable to decode data")
                        completion(nil)
                        return
                    }
                    var tempArray: [Day] = []
                    
                    for data in dataArray {
                        if let day = Day(dayDictionary: data, cityName: cityName) {
                            tempArray.append(day)
                        } else {
                            print("failed top decode day: \(data)")
                        }
                    }
                    completion(tempArray)
                }
            } catch let error {
                print(error)
                completion(nil)
            }
        }.resume()
    }
}
