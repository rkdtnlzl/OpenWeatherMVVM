//
//  Forecast.swift
//  OpenWeatherMVVM
//
//  Created by 강석호 on 7/13/24.
//

import Foundation

struct WeatherForecastData: Codable {
    let list: [Forecast]
}

struct Forecast: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
}
