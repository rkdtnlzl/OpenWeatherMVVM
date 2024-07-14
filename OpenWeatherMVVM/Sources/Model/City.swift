//
//  City.swift
//  OpenWeatherMVVM
//
//  Created by 강석호 on 7/14/24.
//

import Foundation

struct City: Codable {
    let id: Int
    let name: String
    let state: String
    let country: String
    let coord: CoordData
}

struct CoordData: Codable {
    let lon: Double
    let lat: Double
}
