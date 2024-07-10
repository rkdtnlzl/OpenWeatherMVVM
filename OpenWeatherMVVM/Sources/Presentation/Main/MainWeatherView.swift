//
//  MainWeatherView.swift
//  OpenWeatherMVVM
//
//  Created by 강석호 on 7/10/24.
//

import UIKit
import SnapKit

class MainWeatherView: BaseView {
    
    let cityName = UILabel()
    let currentTemp = UILabel()
    
    override func configureHierarchy() {
        addSubview(cityName)
        addSubview(currentTemp)
    }
    
    override func configureView() {
        cityName.text = "test"
        cityName.textColor = .white
        cityName.font = .systemFont(ofSize: 35, weight: .regular)
        cityName.textAlignment = .center
        
        currentTemp.text = "5.9C"
        currentTemp.textColor = .white
        currentTemp.font = .systemFont(ofSize: 45, weight: .thin)
        currentTemp.textAlignment = .center
    }
    
    override func configureLayout() {
        cityName.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        currentTemp.snp.makeConstraints { make in
            make.top.equalTo(cityName.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
}
