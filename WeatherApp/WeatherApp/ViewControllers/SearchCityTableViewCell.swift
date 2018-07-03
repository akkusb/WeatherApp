//
//  SearchCityTableViewCell.swift
//  WeatherApp
//
//  Created by Burhan on 02/07/2018.
//  Copyright © 2018 Burhan. All rights reserved.
//

import UIKit

class SearchCityTableViewCell: BaseTableViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func refreshCellWithData(_ cellData: Any?) {
        if let cityName : String = cellData as? String{
            self.cityNameLabel.text = cityName
        }
    }
    
}
