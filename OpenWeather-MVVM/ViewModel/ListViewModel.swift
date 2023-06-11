//
//  ListViewModel.swift
//  OpenWeather-MVVM

import Foundation

enum SectionType: CaseIterable {
    case recent
    case current
}

protocol ListViewModelOutputProtocol {
    func refreshList(weatherDetails: WeatherDetails)
    func showError(errorMessage: String)
    func showLoader()
    func hideLoader()
}

class ListViewModel: NSObject {
    
    private var listViewModelDelegate: ListViewModelOutputProtocol!
    public var weatherDetails: WeatherDetails?
    var networkManager: NetworkManagerProtocol
    
    init(delegate: ListViewModelOutputProtocol,
         manager: NetworkManagerProtocol = NetworkManager()) {
        listViewModelDelegate = delegate
        networkManager = manager
    }
    
    func searchByCityName(cityName: String) {
        listViewModelDelegate.showLoader()
        networkManager.getWeatherDetails(searchText: cityName) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.listViewModelDelegate.hideLoader()
                self?.weatherDetails = nil
                self?.listViewModelDelegate.showError(errorMessage: error.localizedDescription)
            case .success(let weatherDetails):
                self?.listViewModelDelegate.hideLoader()
                self?.weatherDetails = weatherDetails
                self?.listViewModelDelegate.refreshList(weatherDetails: weatherDetails)
            }
        }
    }
    
    func addCityToRecentList() {
        let recentCities = UserDefaults.standard.object(forKey: "recent_cities") as? [String]
        var cities = (recentCities == nil) ? Set<String>() : Set(recentCities ?? [String]())
        cities.insert(cityName)
        UserDefaults.standard.set(Array(cities), forKey: "recent_cities")
    }
    
    public var sections: [SectionType] {
        SectionType.allCases
    }
    
    public func getNumberOfRows(for section: SectionType) -> Int {
        switch section {
        case .recent:
            let recentCities = UserDefaults.standard.object(forKey: "recent_cities") as? [String]
            return recentCities?.count ?? 0
        case .current:
            return (weatherDetails == nil) ? 0 : 1
        }
    }
    
    public func recentCityName(index: Int) -> String {
        let recentCities = UserDefaults.standard.object(forKey: "recent_cities") as? [String]
        return recentCities?[index] ?? ""
    }
    
    public var cityId: Int {
        weatherDetails?.id ?? 0
    }
    
    public var cityName: String {
        weatherDetails?.name ?? ""
    }
    
    public var weatherDescription: String {
        guard let humidity = weatherDetails?.main?.humidity,
              let seaLevel = weatherDetails?.main?.humidity,
              let desc = weatherDetails?.weather?.first?.description else { return "" }
        return "Humidity: \(humidity), Sea Level: \(seaLevel), Description: \(desc)"
    }
    
    public var icon: String {
        weatherDetails?.weather?.first?.icon ?? ""
    }
}
