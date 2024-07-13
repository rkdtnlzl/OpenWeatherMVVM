//
//  ViewController.swift
//  OpenWeatherMVVM
//
//  Created by 강석호 on 7/10/24.
//

import UIKit
import CoreLocation
import Kingfisher

class MainWeatherViewController: BaseViewController {
    
    let scrollView = UIScrollView()
    let mainWeatherView = MainWeatherView()
    
    lazy var threeHoursCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(width: 80, height: 140)
        
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
    
    let fiveDaysTableView = UITableView()
    let viewModel = MainWeatherViewModel()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        configureTableView()
        bindData()
    }
    
    func configureTableView() {
        fiveDaysTableView.delegate = self
        fiveDaysTableView.dataSource = self
        fiveDaysTableView.register(FiveDaysTableViewCell.self, forCellReuseIdentifier: FiveDaysTableViewCell.id)
        fiveDaysTableView.rowHeight = 70
        fiveDaysTableView.backgroundColor = .clear
        fiveDaysTableView.layer.cornerRadius = 10
        fiveDaysTableView.layer.borderColor = UIColor.lightGray.cgColor
        fiveDaysTableView.layer.borderWidth = 0.5
        fiveDaysTableView.isScrollEnabled = false
    }
    
    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainWeatherView)
        scrollView.addSubview(threeHoursCollectionView)
        scrollView.addSubview(fiveDaysTableView)
    }
    
    override func configureView() {
        scrollView.backgroundColor = .black
    }
    
    override func configureConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        mainWeatherView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(180)
        }
        threeHoursCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mainWeatherView.snp.bottom).offset(40)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(140)
        }
        fiveDaysTableView.snp.makeConstraints { make in
            make.top.equalTo(threeHoursCollectionView.snp.bottom).offset(40)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(350)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
    }
    
    func formatDate(_ timestamp: Int, index: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        if index == 0 {
            return "오늘"
        } else {
            let weekdayIndex = calendar.component(.weekday, from: date)
            dateFormatter.dateFormat = "E"
            return dateFormatter.shortWeekdaySymbols[weekdayIndex - 1]
        }
    }
    
    func formatTime(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH시"
        return dateFormatter.string(from: date)
    }
    
    func getIconURL(iconCode: String) -> String {
        return "\(APIURL.iconURL)\(iconCode)@2x.png"
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        WeatherAPI.shared.loadImage(from: urlString, completion: completion)
    }
    
    func bindData() {
        viewModel.outputWeatherUpdate.bind { weatherUpdate in
            self.mainWeatherView.cityName.text = weatherUpdate.cityName
            self.mainWeatherView.currentTemp.text = weatherUpdate.currentTemp
            self.mainWeatherView.descriptionName.text = weatherUpdate.descriptionName
            self.mainWeatherView.minMaxTemp.text = weatherUpdate.minMaxTemp
        }
        viewModel.outputThreeHoursWeather.bind { _ in
            self.threeHoursCollectionView.reloadData()
        }
        viewModel.outputFiveDaysWeather.bind { _ in
            self.fiveDaysTableView.reloadData()
        }
    }
}

extension MainWeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputThreeHoursWeather.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThreeHoursCollectionViewCell.id, for: indexPath) as! ThreeHoursCollectionViewCell
        let forecast = viewModel.outputThreeHoursWeather.value[indexPath.item]
        let time = formatTime(TimeInterval(forecast.dt))
        let temperature = String(format: "%.1f°C", viewModel.convertCelsius(kelvin: forecast.main.temp ?? 0.0))
        let icon = forecast.weather.first?.icon ?? ""
        let iconURL = getIconURL(iconCode: icon)
        
        cell.timeLabel.text = time
        cell.temperatureLabel.text = temperature
        cell.iconImageView.kf.setImage(with: URL(string: iconURL))
        
        return cell
    }
    
}

extension MainWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputFiveDaysWeather.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FiveDaysTableViewCell.id, for: indexPath) as! FiveDaysTableViewCell
        
        let forecast = viewModel.outputFiveDaysWeather.value[indexPath.row]
        let mintemp = String(format: "%.1f°C", viewModel.convertCelsius(kelvin: forecast.main.tempMin ?? 0.0))
        let maxtemp = String(format: "%.1f°C", viewModel.convertCelsius(kelvin: forecast.main.tempMax ?? 0.0))
        
        cell.dateLabel.text = formatDate(forecast.dt, index: indexPath.row)
        cell.minTempLabel.text = "최저: \(mintemp)"
        cell.maxTempLabel.text = "최고: \(maxtemp)"
        
        let icon = forecast.weather.first?.icon ?? ""
        let iconURL = getIconURL(iconCode: icon)
        cell.weatherIcon.kf.setImage(with: URL(string: iconURL))
        
        cell.backgroundColor = .clear
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
