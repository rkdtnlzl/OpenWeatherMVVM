//
//  DetailWeatherCollectionViewCell.swift
//  OpenWeatherMVVM
//
//  Created by 강석호 on 7/14/24.
//

import UIKit
import SnapKit

class DetailWeatherCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "DetailWeatherCollectionViewCell"
    
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override func configureHierarchy() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
    }
    
    override func configureView() {
        iconImageView.image = UIImage(systemName: "star")
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .gray
        
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = .gray
        titleLabel.text = "바람속도"
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 30)
        descriptionLabel.textColor = .white
        descriptionLabel.text = "50%"
    }
    
    override func configureLayout() {
        iconImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(15)
            make.size.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.equalTo(iconImageView.snp.trailing).offset(5)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(15)
        }
    }
}
