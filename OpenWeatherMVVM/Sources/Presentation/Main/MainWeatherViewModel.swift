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
    var outputThreeHoursWeather: Observable<[Forecast]> = Observable([])
    var outputFiveDaysWeather: Observable<[Forecast]> = Observable([])
    
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
                    minMaxTemp: "최고 : \(formattedMaxTemp) | 최저 : \(formattedMinTemp)"
                )
                self.fetchForecast(cityId: weatherData.id)
                
            case .failure:
                self.outputWeatherUpdate.value = ("Error", "N/A", "N/A", "N/A | N/A")
            }
        }
    }
    
    private func fetchForecast(cityId: Int) {
        WeatherAPI.shared.fetchWeatherForecast(cityId: cityId) { result in
            switch result {
            case .success(let forecastData):
                let forecasts = forecastData.list
                self.outputThreeHoursWeather.value = Array(forecasts.prefix(8))
                self.fiveDaysForecasts(forecasts: forecasts)
            case .failure:
                self.outputThreeHoursWeather.value = []
                self.outputFiveDaysWeather.value = []
            }
        }
    }
    
    private func fiveDaysForecasts(forecasts: [Forecast]) {
        var dailyForecasts: [Forecast] = []
        let groupedForecasts = Dictionary(grouping: forecasts) { forecast in
            let date = Date(timeIntervalSince1970: TimeInterval(forecast.dt))
            let calendar = Calendar.current
            return calendar.startOfDay(for: date)
        }
        
        for (_, dailyData) in groupedForecasts {
            if let dailyForecast = dailyData.first {
                dailyForecasts.append(dailyForecast)
            }
        }
        
        dailyForecasts.sort { $0.dt < $1.dt }
        self.outputFiveDaysWeather.value = dailyForecasts
    }
    
    func convertCelsius(kelvin: Double) -> Double {
        return kelvin - 273.15
    }
}
