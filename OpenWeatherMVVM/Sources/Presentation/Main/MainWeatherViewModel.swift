//
//  MainWeatherViewModel.swift
//  OpenWeatherMVVM
//
//  Created by 강석호 on 7/10/24.
//

import Foundation

class MainWeatherViewModel {
    
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    
    var outputWeatherUpdate: Observable<(cityName: String, currentTemp: String)> = Observable(("", ""))
    
    init() {
        inputViewDidLoadTrigger.bind { _ in
            self.fetchWeather()
        }
    }
    
    func fetchWeather() {
        WeatherAPI.shared.fetchWeatherData(latitude: 37.74913611, longitude: 128.8784972) {  result in
            switch result {
            case .success(let weatherData):
                let celsiusTemp = self.convertCelsius(kelvin: weatherData.main.temp ?? 0.0)
                let formattedTemp = String(format: "%.1f°C", celsiusTemp)
                self.outputWeatherUpdate.value = (cityName: weatherData.name, currentTemp: formattedTemp)
            case .failure:
                self.outputWeatherUpdate.value = ("Error", "N/A")
            }
        }
    }
    
    private func convertCelsius(kelvin: Double) -> Double {
        return kelvin - 273.15
    }
}
