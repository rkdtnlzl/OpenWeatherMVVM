//
//  MainWeatherViewModel.swift
//  OpenWeatherMVVM
//
//  Created by 강석호 on 7/10/24.
//

import Foundation

class MainWeatherViewModel {
    
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    
    var outputWeatherUpdate: Observable<(cityName: String, currentTemp: String, descriptionName: String)> = Observable(("", "", ""))
    
    private let locationManager = LocationManager()
    
    init() {
        inputViewDidLoadTrigger.bind { _ in
            self.requestLocation()
        }
    }
    
    private func requestLocation() {
        locationManager.fetchLocation { [weak self] coordinate, error in
            if let coordinate = coordinate {
                self?.fetchWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
            } else if let error = error {
                print("Error fetching location: \(error)")
                self?.outputWeatherUpdate.value = ("Location Error", "N/A", "N/A")
            }
        }
    }
    
    func fetchWeather(latitude: Double, longitude: Double) {
        WeatherAPI.shared.fetchWeatherData(latitude: latitude, longitude: longitude) { result in
            switch result {
            case .success(let weatherData):
                let celsiusTemp = self.convertCelsius(kelvin: weatherData.main.temp ?? 0.0)
                let formattedTemp = String(format: "%.1f°C", celsiusTemp)
                self.outputWeatherUpdate.value = (cityName: weatherData.name, currentTemp: formattedTemp, descriptionName: weatherData.weather.first?.description ?? "")
            case .failure:
                self.outputWeatherUpdate.value = ("Error", "N/A", "N/A")
            }
        }
    }
    
    private func convertCelsius(kelvin: Double) -> Double {
        return kelvin - 273.15
    }
}
