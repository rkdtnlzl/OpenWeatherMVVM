//
//  MainWeatherViewModel.swift
//  OpenWeatherMVVM
//
//  Created by 강석호 on 7/10/24.
//

import Foundation

class MainWeatherViewModel {
    
    var inputLocationTrigger: Observable<(latitude: Double, longitude: Double)> = Observable((0.0, 0.0))
    
    var outputWeatherUpdate: Observable<(cityName: String, currentTemp: String, descriptionName: String, minMaxTemp: String)> = Observable(("", "", "", ""))
    
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
                
                let celsiusMinTemp = self.convertCelsius(kelvin: weatherData.main.tempMin ?? 0.0)
                let formattedMinTemp = String(format: "%.1f°C", celsiusMinTemp)
                
                let celsiusMaxTemp = self.convertCelsius(kelvin: weatherData.main.tempMax ?? 0.0)
                let formattedMaxTemp = String(format: "%.1f°C", celsiusMaxTemp)
                
                self.outputWeatherUpdate.value = (
                    cityName: weatherData.name,
                    currentTemp: formattedTemp,
                    descriptionName: weatherData.weather.first?.description ?? "",
                    minMaxTemp: "최고 : \(formattedMinTemp) | 최저 : \(formattedMaxTemp)"
                )
            case .failure:
                self.outputWeatherUpdate.value = ("Error", "N/A", "N/A", "N/A | N/A")
            }
        }
    }
    
    private func convertCelsius(kelvin: Double) -> Double {
        return kelvin - 273.15
    }
}
