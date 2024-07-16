//
//  ViewController.swift
//  OpenWeatherMVVM
//
//  Created by 강석호 on 7/10/24.
//

import UIKit
import CoreLocation
import Kingfisher
import MapKit

class MainWeatherViewController: BaseViewController {
    
    let containerView = UIView()
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
    
    lazy var detailWeatherCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        let itemSize = (UIScreen.main.bounds.width - 24) / 2
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(DetailWeatherCollectionViewCell.self, forCellWithReuseIdentifier: DetailWeatherCollectionViewCell.id)
        return collectionView
    }()
    
    let fiveDaysTableView = UITableView()
    let mapView = MKMapView()
    let toolbar = UIToolbar()

    let viewModel = MainWeatherViewModel()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        configureTableView()
        configureToolbar()
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
    
    func configureToolbar() {
        toolbar.barStyle = .default
        toolbar.barTintColor = .clear
        toolbar.tintColor = .white
        let leftItem = UIBarButtonItem(image: UIImage(systemName: "map"), style: .plain, target: self, action: #selector(leftButtonTapped))
        let rightItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(rightButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [leftItem, flexibleSpace, rightItem]
    }
    
    override func configureHierarchy() {
        view.addSubview(containerView)
        containerView.addSubview(scrollView)
        containerView.addSubview(toolbar)
        
        scrollView.addSubview(mainWeatherView)
        scrollView.addSubview(threeHoursCollectionView)
        scrollView.addSubview(fiveDaysTableView)
        scrollView.addSubview(mapView)
        scrollView.addSubview(detailWeatherCollectionView)
    }
    
    override func configureView() {
        scrollView.backgroundColor = .black
        mapView.layer.cornerRadius = 10
        mapView.isScrollEnabled = false
    }
    
    override func configureConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(containerView)
            make.bottom.equalTo(toolbar.snp.top)
        }
        toolbar.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(containerView)
            make.height.equalTo(50)
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
        }
        mapView.snp.makeConstraints { make in
            make.top.equalTo(fiveDaysTableView.snp.bottom).offset(40)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(250)
        }
        detailWeatherCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(40)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(400)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
    }
    
    @objc func leftButtonTapped() {
        let vc = CitySearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func rightButtonTapped() {
        
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
        viewModel.outputDetailWeather.bind { _ in
            self.detailWeatherCollectionView.reloadData()
        }
    }
}

extension MainWeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == threeHoursCollectionView {
            return viewModel.outputThreeHoursWeather.value.count
        } else {
            return viewModel.outputDetailWeather.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == threeHoursCollectionView {
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
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailWeatherCollectionViewCell.id, for: indexPath) as! DetailWeatherCollectionViewCell
            let detail = viewModel.outputDetailWeather.value[indexPath.item]
            cell.layer.cornerRadius = 10
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 0.5
            cell.titleLabel.text = detail.title
            cell.descriptionLabel.text = detail.value
            let imageName = ["wind", "drop.fill", "thermometer.transmission", "humidity"][indexPath.item % 4]
            cell.iconImageView.image = UIImage(systemName: imageName)
            return cell
        }
    }
    
}

extension MainWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputFiveDaysWeather.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FiveDaysTableViewCell.id, for: indexPath) as! FiveDaysTableViewCell
        let forecast = viewModel.outputFiveDaysWeather.value[indexPath.row]
        cell.dateLabel.text = formatDate(forecast.date, index: indexPath.row)
        cell.minTempLabel.text = "최저: \(String(format: "%.1f°C", forecast.minTemp))"
        cell.maxTempLabel.text = "최고: \(String(format: "%.1f°C", forecast.maxTemp))"
        let iconURL = getIconURL(iconCode: forecast.weatherIcon)
        cell.weatherIcon.kf.setImage(with: URL(string: iconURL))
        cell.backgroundColor = .clear
        return cell
    }
    
    func formatDate(_ date: Date, index: Int) -> String {
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

