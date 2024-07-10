//
//  BaseViewController.swift
//  OpenWeatherMVVM
//
//  Created by 강석호 on 7/10/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureHierarchy()
        configureView()
        configureConstraints()
        configureTarget()
    }
    
    func configureNavigation() { }
     
    func configureHierarchy() { }
    
    func configureView() { }
    
    func configureConstraints() { }
    
    func configureTarget() { }
}
