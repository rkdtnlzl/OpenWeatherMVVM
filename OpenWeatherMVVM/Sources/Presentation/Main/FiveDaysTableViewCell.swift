//
//  FiveDaysTableViewCell.swift
//  OpenWeatherMVVM
//
//  Created by 강석호 on 7/13/24.
//

import UIKit
import SnapKit

class FiveDaysTableViewCell: BaseTableViewCell {
    
    static let id = "FiveDaysTableViewCell"
    
    let dateLabel = UILabel()
    let weatherIcon = UIImageView()
    let minTempLabel = UILabel()
    let maxTempLabel = UILabel()
    let stackView = UIStackView()
    
    override func configureHierarchy() {
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(weatherIcon)
        stackView.addArrangedSubview(minTempLabel)
        stackView.addArrangedSubview(maxTempLabel)
        addSubview(stackView)
    }
    
    override func configureView() {
        dateLabel.text = "오늘"
        dateLabel.font = .systemFont(ofSize: 20)
        dateLabel.textColor = .white
        
        weatherIcon.contentMode = .scaleAspectFit
        weatherIcon.image = UIImage(systemName: "star")
        
        minTempLabel.text = "최저: 33도"
        minTempLabel.font = .systemFont(ofSize: 20)
        minTempLabel.textColor = .gray
        
        maxTempLabel.text = "최고: 33도"
        maxTempLabel.font = .systemFont(ofSize: 20)
        maxTempLabel.textColor = .white
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(15)
        }
        
        weatherIcon.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
    }
}
