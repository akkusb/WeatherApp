//
//  CityDetailTableViewCell.swift
//  WeatherApp
//
//  Created by Burhan on 03/07/2018.
//  Copyright © 2018 Burhan. All rights reserved.
//

import UIKit

class CityDetailTableViewCell: BaseTableViewCell {

    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func refreshCellWithData(_ cellData: Any?) {
        if let weatherModel : WeatherModel = cellData as? WeatherModel{
            self.dateLabel.text = weatherModel.dt_txt
        }
    }
    
}
