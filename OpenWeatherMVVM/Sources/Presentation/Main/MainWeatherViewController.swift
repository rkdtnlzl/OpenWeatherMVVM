//
//  ViewController.swift
//  OpenWeatherMVVM
//
//  Created by 강석호 on 7/10/24.
//

import UIKit

class MainWeatherViewController: BaseViewController {
    
    let scrollView = UIScrollView()
    let mainWatherView = MainWeatherView()
    let viewModel = MainWeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        viewModel.inputViewDidLoadTrigger.value = ()
    }
    
    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainWatherView)
    }
    
    override func configureView() {
        scrollView.backgroundColor = .black
    }
    
    override func configureConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        mainWatherView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(180)
        }
    }
    
    func bindData() {
        viewModel.outputWeatherUpdate.bind { weatherUpdate in
            self.mainWatherView.cityName.text = weatherUpdate.cityName
            self.mainWatherView.currentTemp.text = weatherUpdate.currentTemp
            self.mainWatherView.descriptionName.text = weatherUpdate.descriptionName
            
            print("==========\(weatherUpdate.descriptionName)")
        }
    }
}

