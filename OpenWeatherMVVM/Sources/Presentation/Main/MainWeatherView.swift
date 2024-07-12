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
    let descriptionName = UILabel()
    let minMaxTemp = UILabel()
    
    override func configureHierarchy() {
        addSubview(cityName)
        addSubview(currentTemp)
        addSubview(descriptionName)
        addSubview(minMaxTemp)
    }
    
    override func configureView() {
        cityName.text = "loading..."
        cityName.textColor = .white
        cityName.font = .systemFont(ofSize: 35, weight: .regular)
        cityName.textAlignment = .center
        
        currentTemp.text = "loading.."
        currentTemp.textColor = .white
        currentTemp.font = .systemFont(ofSize: 45, weight: .thin)
        currentTemp.textAlignment = .center
        
        descriptionName.text = "loading.."
        descriptionName.textColor = .white
        descriptionName.font = .systemFont(ofSize: 25)
        descriptionName.textAlignment = .center
        
        minMaxTemp.text = "loading.."
        minMaxTemp.textColor = .white
        minMaxTemp.font = .systemFont(ofSize: 22)
        minMaxTemp.textAlignment = .center
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
        descriptionName.snp.makeConstraints { make in
            make.top.equalTo(currentTemp.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        minMaxTemp.snp.makeConstraints { make in
            make.top.equalTo(descriptionName.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
}
