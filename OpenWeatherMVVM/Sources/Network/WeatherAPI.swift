//
//  WeatherAPI.swift
//  OpenWeatherMVVM
//
//  Created by 강석호 on 7/10/24.
//

import Foundation
import Alamofire
import UIKit

class WeatherAPI {
    
    static let shared = WeatherAPI()
    
    private init() { }
    
    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (Result<CurrentWeather, Error>) -> Void) {
        let parameters: [String: Any] = [
            "lat": latitude,
            "lon": longitude,
            "appid": APIKey.weatherKey
        ]
        AF.request(APIURL.weatherURL, method: .get, parameters: parameters).responseDecodable(of: CurrentWeather.self) { response in
            switch response.result {
            case .success(let weatherData):
                print(weatherData)
                completion(.success(weatherData))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func fetchWeatherForecast(cityId: Int, completion: @escaping (Result<WeatherForecastData, Error>) -> Void) {
        let parameters: [String: Any] = [
            "id": cityId,
            "appid": APIKey.weatherKey
        ]
        AF.request(APIURL.forcastURL, method: .get, parameters: parameters).responseDecodable(of: WeatherForecastData.self) { response in
            switch response.result {
            case .success(let forecastData):
                print(forecastData)
                completion(.success(forecastData))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(image)
                }
            case .failure:
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
