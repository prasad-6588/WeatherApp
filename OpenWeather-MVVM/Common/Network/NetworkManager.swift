//
//  NetworkManager.swift
//  OpenWeather-MVVM

import Foundation

protocol NetworkManagerProtocol {
    func getWeatherDetails(searchText: String, completion: @escaping(Result<WeatherDetails, CommonError>) -> Void)
}

enum CommonError: Error {
    case noDataAvailable
    case canNotProcessData
}

final class NetworkManager: NetworkManagerProtocol {
    
    public init() {}
    
    func getWeatherDetails(searchText: String, completion: @escaping(Result<WeatherDetails, CommonError>) -> Void) {
        
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(searchText)&APPID=4ddb84730a9c3d0932da9dfa7d527b0d") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data,_,_ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let decoder = JSONDecoder()
                let weatherDetails = try decoder.decode(WeatherDetails.self, from: jsonData)
                completion(.success(weatherDetails))
            }
            catch{
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
}

class MockNetworkManager: NetworkManagerProtocol {
    
    var isApiCalled = false
    
    func getWeatherDetails(searchText: String, completion: @escaping(Result<WeatherDetails, CommonError>) -> Void) {
        
        isApiCalled = true
        
        let decoder = JSONDecoder()
        do {
            let jsonString = """
            {"coord":{"lon":73.8553,"lat":18.5196},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04n"}],"base":"stations","main":{"temp":299.74,"feels_like":299.74,"temp_min":299.74,"temp_max":299.74,"pressure":1008,"humidity":63,"sea_level":1008,"grnd_level":947},"visibility":10000,"wind":{"speed":3.58,"deg":233,"gust":8.54},"clouds":{"all":69},"dt":1686418472,"sys":{"country":"IN","sunrise":1686356851,"sunset":1686404431},"timezone":19800,"id":1259229,"name":"Pune","cod":200}
            """
            let jsonData = Data(jsonString.utf8)
            let weatherDetails = try decoder.decode(WeatherDetails.self, from: jsonData)
            completion(.success(weatherDetails))
        } catch {
            completion(.failure(.canNotProcessData))
        }
    }
}
