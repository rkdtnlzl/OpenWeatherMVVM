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
        WeatherAPI.shared.fetchWeatherData(latitude: 37.74913611, longitude: 128.8784972) { [weak self] result in
            switch result {
            case .success(let weatherData):
                DispatchQueue.main.async {
                    let formattedTemp = String(format: "%.1f°C", weatherData.main.temp)
                    self?.outputWeatherUpdate.value = (cityName: weatherData.name, currentTemp: formattedTemp)
                }
            case .failure:
                DispatchQueue.main.async {
                    self?.outputWeatherUpdate.value = ("Error", "N/A")
                }
            }
        }
    }
}
