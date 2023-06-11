//
//  WeatherDetails.swift
//  OpenWeather-MVVM

import Foundation

public struct WeatherDetails: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

public struct Clouds: Codable {
    let all: Int?
}

public struct Coord: Codable {
    let lon, lat: Double?
}

public struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

public struct Sys: Codable {
    let type, id: Int?
    let country: String?
    let sunrise, sunset: Int?
}

public struct Weather: Codable {
    let id: Int?
    let main, description, icon: String?
}

public struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}
