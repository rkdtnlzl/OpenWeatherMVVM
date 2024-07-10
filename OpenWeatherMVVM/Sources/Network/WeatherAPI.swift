//
//  WeatherAPI.swift
//  OpenWeatherMVVM
//
//  Created by 강석호 on 7/10/24.
//

import Foundation
import Alamofire

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
}
