//
//  JSONParser.swift
//  OpenWeatherMVVM
//
//  Created by 강석호 on 7/14/24.
//

import Foundation

class JSONParser {
    static func loadCities(from filename: String) -> [City]? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let cities = try decoder.decode([City].self, from: data)
            return cities
        } catch {
            print("Error parsing JSON: \(error)")
            return nil
        }
    }
}
