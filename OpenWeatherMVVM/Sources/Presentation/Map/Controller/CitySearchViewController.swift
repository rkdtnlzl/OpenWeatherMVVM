//
//  CitySearchViewController.swift
//  OpenWeatherMVVM
//
//  Created by 강석호 on 7/14/24.
//

import UIKit
import SnapKit

class CitySearchViewController: BaseViewController {
    
    let cityTitle = UILabel()
    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    let viewModel = CitySearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearchBar()
        bindData()
    }
    
    override func configureHierarchy() {
        view.addSubview(cityTitle)
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    override func configureView() {
        cityTitle.text = "City"
        cityTitle.font = .systemFont(ofSize: 33, weight: .heavy)
        cityTitle.textColor = .white
    }
    
    override func configureConstraints() {
        cityTitle.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(cityTitle.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .black
    }
    
    func configureSearchBar() {
        searchBar.delegate = self
        searchBar.barTintColor = .black
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .white
            textField.backgroundColor = .black
            textField.tintColor = .white
            textField.attributedPlaceholder = NSAttributedString(string: "Search for a city.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    }
    
    func bindData() {
        viewModel.outputFilteredCities.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
}

extension CitySearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.inputSearchText.value = searchText
    }
}

extension CitySearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputFilteredCities.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let city = viewModel.outputFilteredCities.value[indexPath.row]
        cell.textLabel?.text = "\(city.name)"
        cell.detailTextLabel?.text = "\(city.country)"
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .lightGray
        cell.backgroundColor = .black
        return cell
    }
}
