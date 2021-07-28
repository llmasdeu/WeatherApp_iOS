//
//  APIManager.swift
//  WeatherApp
//
//  Created by Lluís Masdeu on 02/12/2019.
//  Copyright © 2019 Lluís Masdeu. All rights reserved.
//

import Foundation
import Alamofire

private let APIKey = "6f45141124475e9745e86facc8e74c61"
// Documentation: https://openweathermap.org/current
// private let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(APIKey)"
// Documentation: https://openweathermap.org/forecast5
private let baseURL = "https://api.openweathermap.org/data/2.5/forecast?appid=\(APIKey)"
private let units = "metric"

class APIManager {
    static let shared = APIManager()

    //
    // Constructor the class APIManager
    //
    init(){ }

    /*
    //
    // Function responsible of getting the weather results of a coordinates
    //
    func requestWeatherForCity(city: String, callback: @escaping (_ data: ResponseData) -> Void) {
        // Setting the city name for the request
        let cityQuery = city.replacingOccurrences(of: " ", with: "+")
        
        // Sending the request to the API URL
        let urlString = "\(baseURL)&q=\(cityQuery)&units=\(units)"
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        print(urlString)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        // Getting and processing the response of the API
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            // Defining the object in charge of storing the data of the response
            var responseData: ResponseData = ResponseData()
            
            // Setting the 404 error code as a placeholder
            responseData.responseCode = "404"
            
            // Checking any possible errors throughout the process
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!.statusCode) // only 200 is a valid response
                
                // Checking the status code and any possible errors
                if httpResponse!.statusCode == 200 {
                    if let data = data {
                        if let jsonString = String(data: data, encoding: .utf8) {
                            if let jsonData = jsonString.data(using: .utf8) {
                                let decoder = JSONDecoder()
                                
                                // Decoding the JSON with the response
                                responseData = try! decoder.decode(ResponseData.self, from: jsonData)
                            }
                        }
                    }
                }
            }
            
            // Calling the callback function with the response data parsed
            callback(responseData)
        })
        
        // Resuming after the API request
        dataTask.resume()
    }
    */
    
    //
    // Function responsible of getting the weather results of a coordinates
    //
    func requestWeatherForCity(city: String, callback: @escaping (_ data: ResponseData) -> Void) {
        // Generates the API URL
        let urlString = URL(string: baseURL)
        print("\(baseURL)?q=\(city)&units=\(units)")
        
        // Sending the request to the API
        AF.request(baseURL, method: .get, parameters: ["q": city, "units": units]).validate().responseJSON { response in
            // Defining the object in charge of storing the data of the response
            var responseData: ResponseData = ResponseData()
            
            // Setting the 404 error code as a placeholder
            responseData.responseCode = "404"
            
            // Checking any possible errors
            if response.error != nil {
                print("THERE'S BEEN SOME ERROR")
            } else {
                if response.response?.statusCode == 200 {
                    if let data = response.data {
                        if let jsonString = String(data: data, encoding: .utf8) {
                            if let jsonData = jsonString.data(using: .utf8) {
                                let decoder = JSONDecoder()
                                
                                // Decoding the JSON with the response
                                responseData = try! decoder.decode(ResponseData.self, from: jsonData)
                            }
                        }
                    }
                }
            }
            
            // Calling the callback function with the response data parsed
            callback(responseData)
        }
    }
    
    /*
    //
    // Function responsible of getting the weather results of a coordinates
    //
    func requestWeatherForCoordinates(latitude: Double, longitude: Double, callback: @escaping (_ data: ResponseData) -> Void) {
        // Sending the request to the API URL
        let urlString = "\(baseURL)&lat=\(latitude)&lon=\(longitude)&units=\(units)"
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        print(urlString)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        // Getting and processing the response of the API
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            // Defining the object in charge of storing the data of the response
            var responseData: ResponseData = ResponseData()
            
            // Setting the 404 error code as a placeholder
            responseData.responseCode = "404"
            
            // Checking any possible errors throughout the process
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!.statusCode) // only 200 is a valid response
                
                // Checking the status code and any possible errors
                if httpResponse!.statusCode == 200 {
                    if let data = data {
                        if let jsonString = String(data: data, encoding: .utf8) {
                            if let jsonData = jsonString.data(using: .utf8) {
                                let decoder = JSONDecoder()
                                
                                // Decoding the JSON with the response
                                responseData = try! decoder.decode(ResponseData.self, from: jsonData)
                            }
                        }
                    }
                }
            }
            
            // Calling the callback function with the response data parsed
            callback(responseData)
        })
        
        // Resuming after the API request
        dataTask.resume()
    }
    */
    
    //
    // Function responsible of getting the weather results of a coordinates
    //
    func requestWeatherForCoordinates(latitude: Double, longitude: Double, callback: @escaping (_ data: ResponseData) -> Void) {
        // Generates the API URL
        let urlString = URL(string: baseURL)
        print("\(baseURL)?lat=\(latitude)&lon=\(longitude)&units=\(units)")
        
        // Sending the request to the API
        AF.request(baseURL, method: .get, parameters: ["lat": latitude, "lon": longitude, "units": units]).validate().responseJSON { response in
            // Defining the object in charge of storing the data of the response
            var responseData: ResponseData = ResponseData()
            
            // Setting the 404 error code as a placeholder
            responseData.responseCode = "404"
            
            // Checking any possible errors
            if response.error != nil {
                print("THERE'S BEEN SOME ERROR")
            } else {
                if response.response?.statusCode == 200 {
                    if let data = response.data {
                        if let jsonString = String(data: data, encoding: .utf8) {
                            if let jsonData = jsonString.data(using: .utf8) {
                                let decoder = JSONDecoder()
                                
                                // Decoding the JSON with the response
                                responseData = try! decoder.decode(ResponseData.self, from: jsonData)
                            }
                        }
                    }
                }
            }
            
            // Calling the callback function with the response data parsed
            callback(responseData)
        }
    }
}
