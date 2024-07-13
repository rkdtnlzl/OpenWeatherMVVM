//
//  ViewController.swift
//  OpenWeatherMVVM
//
//  Created by 강석호 on 7/10/24.
//

import UIKit
import CoreLocation

class MainWeatherViewController: BaseViewController {
    
    let scrollView = UIScrollView()
    let mainWatherView = MainWeatherView()
    lazy var threeHoursCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(width: 80, height: 120)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.layer.cornerRadius = 10
        collectionView.layer.borderColor = UIColor.lightGray.cgColor
        collectionView.layer.borderWidth = 0.5
        collectionView.register(ThreeHoursCollectionViewCell.self, forCellWithReuseIdentifier: ThreeHoursCollectionViewCell.id)
        return collectionView
    }()
    
    let viewModel = MainWeatherViewModel()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        bindData()
    }
    
    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainWatherView)
        scrollView.addSubview(threeHoursCollectionView)
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
        threeHoursCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mainWatherView.snp.bottom).offset(20)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(120)
        }
    }
    
    }
    
    func bindData() {
        viewModel.outputWeatherUpdate.bind { weatherUpdate in
            self.mainWatherView.cityName.text = weatherUpdate.cityName
            self.mainWatherView.currentTemp.text = weatherUpdate.currentTemp
            self.mainWatherView.descriptionName.text = weatherUpdate.descriptionName
            self.mainWatherView.minMaxTemp.text = weatherUpdate.minMaxTemp
        }
    }
}

extension MainWeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputThreeHoursWeather.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cell
    }
    
}
extension MainWeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            viewModel.inputLocationTrigger.value = (latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error)")
    }
}
