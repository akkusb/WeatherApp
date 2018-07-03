//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Burhan on 03/07/2018.
//  Copyright © 2018 Burhan. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    var weatherModel : WeatherModel?
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var seaLevelLabel: UILabel!
    @IBOutlet weak var groundLevelLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initialize()
    }
    
    func initialize() -> Void {
        self.title = "Weather Detail"
        
        self.temperatureLabel.text = self.weatherModel?.main?.temp?.stringValue()
        self.minTemperatureLabel.text = self.weatherModel?.main?.temp_min?.stringValue()
        self.maxTemperatureLabel.text = self.weatherModel?.main?.temp_max?.stringValue()
        self.pressureLabel.text = self.weatherModel?.main?.pressure?.stringValue()
        self.seaLevelLabel.text = self.weatherModel?.main?.sea_level?.stringValue()
        self.groundLevelLabel.text = self.weatherModel?.main?.grnd_level?.stringValue()
        self.humidityLabel.text = self.weatherModel?.main?.humidity?.stringValue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
