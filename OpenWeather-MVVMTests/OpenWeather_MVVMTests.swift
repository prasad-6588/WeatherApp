//
//  OpenWeather_MVVMTests.swift
//  OpenWeather-MVVMTests

import XCTest
@testable import OpenWeather_MVVM

final class OpenWeather_MVVMTests: XCTestCase {
    
    var sut: ListViewModel!
    var mockNetworkManager: MockNetworkManager!

    override func setUp() {
        super.setUp()
        
        mockNetworkManager = MockNetworkManager()
        sut = ListViewModel(delegate: self, manager: mockNetworkManager)
    }
    
    func testWeatherDetailsApiCalled() {
        sut.searchByCityName(cityName: "Pune")
        XCTAssertTrue(mockNetworkManager.isApiCalled)
    }
    
    func testWeatherDetailsNotNil() {
        sut.searchByCityName(cityName: "Pune")
        XCTAssertNotNil(sut.weatherDetails)
    }
    
    func testWeatherDetailsProperties() {
        sut.searchByCityName(cityName: "Pune")
        XCTAssertEqual(sut.weatherDetails?.id, 1259229)
        XCTAssertEqual(sut.weatherDetails?.name, "Pune")
        XCTAssertEqual(sut.weatherDetails?.weather?.first?.icon, "04n")
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        mockNetworkManager = nil
    }
}

// Stubs
extension OpenWeather_MVVMTests: ListViewModelOutputProtocol {
    
    func refreshList(weatherDetails: OpenWeather_MVVM.WeatherDetails) {
        
    }
    
    func showError(errorMessage: String) {
        
    }
    
    func showLoader() {
        
    }
    
    func hideLoader() {
        
    }
}
