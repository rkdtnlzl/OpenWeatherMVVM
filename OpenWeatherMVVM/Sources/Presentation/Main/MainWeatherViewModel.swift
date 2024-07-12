//
//  MainWeatherViewModel.swift
//  OpenWeatherMVVM
//
//  Created by 강석호 on 7/10/24.
//

import Foundation

class MainWeatherViewModel {
    
    var inputLocationTrigger: Observable<(latitude: Double, longitude: Double)> = Observable((0.0, 0.0))
    
    var outputWeatherUpdate: Observable<(cityName: String, currentTemp: String, descriptionName: String)> = Observable(("", "", ""))
    
    init() {
        inputLocationTrigger.bind { location in
            self.fetchWeather(latitude: location.latitude, longitude: location.longitude)
        }
    }
    
    private func fetchWeather(latitude: Double, longitude: Double) {
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
