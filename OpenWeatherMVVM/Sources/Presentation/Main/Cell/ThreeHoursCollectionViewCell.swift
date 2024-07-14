//
//  ThreeHoursCollectionViewCell.swift
//  OpenWeatherMVVM
//
//  Created by 강석호 on 7/13/24.
//

import UIKit
import SnapKit

class ThreeHoursCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "ThreeHoursCollectionViewCell"
    
    let timeLabel = UILabel()
    let iconImageView = UIImageView()
    let temperatureLabel = UILabel()
    
    override func configureHierarchy() {
        addSubview(timeLabel)
        addSubview(iconImageView)
        addSubview(temperatureLabel)
    }
    
    override func configureView() {
        timeLabel.font = UIFont.systemFont(ofSize: 15)
        timeLabel.textColor = .white
        
        temperatureLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        temperatureLabel.textColor = .white
        
        iconImageView.contentMode = .scaleAspectFit
    }
    
    override func configureLayout() {
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
}
