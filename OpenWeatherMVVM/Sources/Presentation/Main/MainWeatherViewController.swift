//
//  ViewController.swift
//  OpenWeatherMVVM
//
//  Created by 강석호 on 7/10/24.
//

import UIKit

class MainWeatherViewController: BaseViewController {
    
    let viewModel = MainWeatherViewModel()
    
    override func loadView() {
        view = MainWeatherView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        viewModel.inputViewDidLoadTrigger.value = ()
    }
    
    func bindData() {
        if let mainWeatherView = view as? MainWeatherView {
            viewModel.outputWeatherUpdate.bind { weatherUpdate in
                mainWeatherView.cityName.text = weatherUpdate.cityName
                mainWeatherView.currentTemp.text = weatherUpdate.currentTemp
            }
        }
    }
}

