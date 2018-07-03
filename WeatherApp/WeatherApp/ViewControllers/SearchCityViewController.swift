//
//  SearchCityViewController.swift
//  WeatherApp
//
//  Created by Burhan on 02/07/2018.
//  Copyright © 2018 Burhan. All rights reserved.
//

import UIKit

class SearchCityViewController: BaseViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
//    var weatherResponseModelList : [WeatherResponseModel] = []
    
    var cityNameList : [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initialize() {
        self.title = "City List"
        
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: "SearchCityTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchCityTableViewCell")
        self.cityNameList = self.loadCityNames()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text{
            self.showHud()
            WeatherService.getWeatherForecast(query: query, success: { [weak self] (weatherResponseModel) in
                if let cityName = weatherResponseModel?.city?.name{
                    _ = self?.addCityNameToList(cityName: cityName)
                    self?.showCityWeatherResponseDetail(cityName: cityName)
                    self?.hideHud()
                }
            }, failure: { [weak self] (err) in
                self?.hideHud()
                UIHelper.showError(error: err)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell : SearchCityTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchCityTableViewCell", for: indexPath) as? SearchCityTableViewCell{
            
            let currentCityName = self.cityNameList[indexPath.row]
            
            cell.refreshCellWithData(currentCityName)
            return cell
        }
        else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Push Detail with weatherResponseModel
        
//        let currentWeatherResponse = self.weatherResponseModelList[indexPath.row]
        
        let currentCityName = self.cityNameList[indexPath.row]
        
        self.showCityWeatherResponseDetail(cityName: currentCityName)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cityNameList.count
    }
    
    func showCityWeatherResponseDetail(cityName: String) -> Void {
        let vc = CityDetailViewController()
        vc.cityName = cityName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func addCityNameToList(cityName: String) -> Bool {
        if self.canAddCityNameToList(cityName: cityName) {
            self.cityNameList.append(cityName)
            
            self.saveCityNames(cityNames: self.cityNameList)
            
            self.tableView.reloadData()
            return true
        }
        else{
            return false
        }
    }
    
    func canAddCityNameToList(cityName: String) -> Bool {
        var isCityNotInList = true
        if self.cityNameList.contains(cityName) {
            isCityNotInList = false
        }
        return isCityNotInList
    }
    
    func saveCityNames(cityNames : [String]) -> Void {
        UserDefaults.standard.set(cityNames, forKey: "CityWeatherResponsesSaveKey")
    }
    
    func loadCityNames() -> [String] {
        
        var cityNames: [String] = []
        if let savedCityNames = UserDefaults.standard.array(forKey: "CityWeatherResponsesSaveKey") as? [String]{
            cityNames = savedCityNames
        }
        return cityNames
    }
    
    
    
    
    
    
    
    
    
//    func addCityWeatherResponseToList(weatherResponseModel: WeatherResponseModel) -> Bool {
//        if self.canAddCityWeatherResponseToList(weatherResponseModel: weatherResponseModel) {
//            self.weatherResponseModelList.append(weatherResponseModel)
//            self.saveCityWeatherResponses(weatherResponses: self.weatherResponseModelList)
//            return true
//        }
//        else{
//            return false
//        }
//    }
//
//    func canAddCityWeatherResponseToList(weatherResponseModel: WeatherResponseModel) -> Bool {
//        var isCityNotInList = true
//        for weatherResponse: WeatherResponseModel in self.weatherResponseModelList {
//            if let cityIdToAdd = weatherResponseModel.city?.id, let currentCityId = weatherResponse.city?.id{
//                if cityIdToAdd == currentCityId{
//                    isCityNotInList = false
//                }
//            }
//        }
//        return isCityNotInList
//    }
//
//
//
//    func saveCityWeatherResponses(weatherResponses : [WeatherResponseModel]) -> Void {
//        UserDefaults.standard.set(weatherResponses, forKey: "CityWeatherResponsesSaveKey")
//    }
//
//    func loadCityWeatherResponses() -> [WeatherResponseModel] {
//
//        var weatherResponseModels: [WeatherResponseModel] = []
//        if let savedWeatherResponseModels = UserDefaults.standard.array(forKey: "CityWeatherResponsesSaveKey") as? [WeatherResponseModel]{
//            weatherResponseModels = savedWeatherResponseModels
//        }
//        return weatherResponseModels
//    }
    
    

}
