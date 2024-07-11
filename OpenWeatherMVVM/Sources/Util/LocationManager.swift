//
//  LocationManager.swift
//  OpenWeatherMVVM
//
//  Created by 강석호 on 7/11/24.
//

import Foundation
import CoreLocation

final class LocationManager: CLLocationManager, CLLocationManagerDelegate {
        
    typealias FetchLocationCompletion = (CLLocationCoordinate2D?, Error?) -> Void

    private var fetchLocationCompletion: FetchLocationCompletion?
    
    override init() {
        super.init()
        
        self.delegate = self
        self.requestWhenInUseAuthorization()
        self.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    /// 현재 사용자 위치 업데이트
    ///
    /// 이 메서드를 여러 번 호출해도 새 이벤트가 생성되지 않으므로, 새로운 이벤트를 받으러면, 꼭 stopUpdatingLocation을 사용 후 사용해야 합니다.
    override func startUpdatingLocation() {
        super.startUpdatingLocation()
    }
    
    /// 위치 업데이트 생성 중지
    override func stopUpdatingLocation() {
        super.stopUpdatingLocation()
    }

    /// 현재 위치를 딱 한번만 전달합니다. (그런데 위치를 받는게 뭔가 느리다)
    override func requestLocation() {
        super.requestLocation()
    }
    
    /// 현재 위치를 받고 컴플리션을 통해 동작을 실행하는 메서드
    func fetchLocation(completion: @escaping FetchLocationCompletion) {
        self.requestLocation()
        self.fetchLocationCompletion = completion
    }
}

extension LocationManager {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let coordinate = location.coordinate
        
        self.fetchLocationCompletion?(coordinate, nil)
        self.fetchLocationCompletion = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to Fetch Location (\(error))")
        self.fetchLocationCompletion?(nil, error)
        self.fetchLocationCompletion = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways , .authorizedWhenInUse:
            print("Location Auth: Allow")
            self.startUpdatingLocation()
        case .notDetermined , .denied , .restricted:
            print("Location Auth: denied")
            self.stopUpdatingLocation()
        default: break
        }
    }
}
