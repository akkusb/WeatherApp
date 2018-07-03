//
//  CityDetailViewController.swift
//  WeatherApp
//
//  Created by Burhan on 03/07/2018.
//  Copyright © 2018 Burhan. All rights reserved.
//

import UIKit

class CityDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var cityName: String?
    var weatherResponseModel : WeatherResponseModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func initialize() -> Void {
        self.title = self.cityName
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: "CityDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "CityDetailTableViewCell")
        self.loadData()
    }
    
    func loadData() -> Void {
        if let query = self.cityName{
            self.showHud()
            WeatherService.getWeatherForecast(query: query, success: { [weak self] (weatherResponseModel) in
                if (weatherResponseModel?.city?.name) != nil{
                    self?.weatherResponseModel = weatherResponseModel
                    self?.tableView.reloadData()
                    self?.hideHud()
                }
            }, failure: { [weak self] (err) in
                self?.hideHud()
                UIHelper.showError(error: err)
            })
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell : CityDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CityDetailTableViewCell", for: indexPath) as? CityDetailTableViewCell{
            let currentWeatherModel = self.weatherResponseModel?.list![indexPath.row]
            
            cell.refreshCellWithData(currentWeatherModel)
            return cell
        }
        else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currentWeatherModel = self.weatherResponseModel?.list![indexPath.row]{
            self.showWeatherDetail(weatherModel: currentWeatherModel)
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherResponseModel?.list?.count ?? 0
    }
    
    func showWeatherDetail(weatherModel: WeatherModel) -> Void {
        let vc = WeatherDetailViewController()
        vc.weatherModel = weatherModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
