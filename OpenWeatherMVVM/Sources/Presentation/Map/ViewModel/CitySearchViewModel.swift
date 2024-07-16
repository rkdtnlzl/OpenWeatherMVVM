//
//  CitySearchViewModel.swift
//  OpenWeatherMVVM
//
//  Created by 강석호 on 7/14/24.
//

import Foundation

class CitySearchViewModel {
    
    var inputSearchText: Observable<String> = Observable("")
    var outputFilteredCities: Observable<[City]> = Observable([])
    
    private var cities: [City] = []
    
    init() {
        loadCities()
        inputSearchText.bind { [weak self] searchText in
            self?.filterCities(with: searchText)
        }
    }
    
    private func loadCities() {
        if let loadedCities = JSONParser.loadCities(from: "CityList") {
            cities = loadedCities
            outputFilteredCities.value = cities
        }
    }
    
    private func filterCities(with searchText: String) {
        if searchText.isEmpty {
            outputFilteredCities.value = cities
        } else {
            outputFilteredCities.value = cities.filter { city in
                city.name.range(of: searchText, options: .caseInsensitive) != nil
            }
        }
    }
}
