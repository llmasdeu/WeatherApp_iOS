//
//  ResponseData.swift
//  WeatherApp
//
//  Created by Lluís Masdeu on 02/12/2019.
//  Copyright © 2019 Lluís Masdeu. All rights reserved.
//

import Foundation

//
// Structures with the response parameters
//
struct ResponseData: Codable {
    var responseCode: String?
    var message: Int?
    var numberOfLines: Int?
    var list: [List] = []
    var city: City?
    
    enum CodingKeys: String, CodingKey {
        case responseCode = "cod"
        case message
        case numberOfLines = "cnt"
        case list
        case city
    }
}

struct List: Codable {
    var timeOfData: Date?
    var main: Main?
    var weather: [Weather] = []
    var clouds: Clouds
    var wind: Wind
    var rain: Rain?
    var snow: Snow?
    var sys: Sys?
    var dateTimeCalculation: String?
    
    enum CodingKeys: String, CodingKey {
        case timeOfData = "dt"
        case main
        case weather
        case clouds
        case wind
        case rain
        case snow
        case sys
        case dateTimeCalculation = "dt_txt"
    }
}

struct Main: Codable {
    var temperature: Double?
    var minTemperature: Double?
    var maxTemperature: Double?
    var pressure: Int?
    var seaLevel: Int?
    var groundLevel: Int?
    var humidity: Int?
    var tempKF: Double?
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
        case humidity
        case tempKF = "temp_kf"
    }
}

struct Weather: Codable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case description
        case icon
    }
}

struct Clouds: Codable {
    var all: Int?
    
    enum CodingKeys: String, CodingKey {
        case all
    }
}

struct Wind: Codable {
    var speed: Double?
    var deg: Int?
    
    enum CodingKeys: String, CodingKey {
        case speed
        case deg
    }
}

struct Rain: Codable {
    var threeHours: Double?
    
    enum CodingKeys: String, CodingKey {
        case threeHours = "3h"
    }
}

struct Snow: Codable {
    var threeHours: Double?
    
    enum CodingKeys: String, CodingKey {
        case threeHours = "3h"
    }
}

struct Sys: Codable {
    var pod: String?
    
    enum CodingKeys: String, CodingKey {
        case pod
    }
}

struct City: Codable {
    var id: Int?
    var name: String?
    var coordinates: Coord?
    var country: String?
    var population: Int?
    var timezone: Int?
    var sunrise: Int?
    var sunset: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case coordinates = "coord"
        case country
        case population
        case timezone
        case sunrise
        case sunset
    }
}

struct Coord: Codable {
    var latitude: Double?
    var longitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}
