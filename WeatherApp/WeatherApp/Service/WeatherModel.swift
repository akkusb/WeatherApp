//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Burhan on 02/07/2018.
//  Copyright © 2018 Burhan. All rights reserved.
//

import UIKit

struct WeatherModel: Codable {
    var dt : Int?
    var dt_txt : String?
    
    var main : WeatherMainModel?
    var weather : [WeatherInfoModel]?
    var clouds : WeatherCloudsModel?
    var wind : WeatherWindModel?
    var sys : WeatherSysModel?
}

struct WeatherMainModel: Codable {
    var temp : Double?
    var temp_min : Double?
    var temp_max : Double?
    var pressure : Double?
    var sea_level : Double?
    var grnd_level : Double?
    var humidity : Double?
    var temp_kf : Double?
}

struct WeatherInfoModel: Codable {
    var id : Int?
    var main : String?
    var description : String?
    var icon : String?
}

struct WeatherCloudsModel: Codable {
    var all : Int?
}

struct WeatherWindModel: Codable {
    var speed : Double?
    var deg : Double?
}

struct WeatherSysModel: Codable {
    var pod : String?
}

struct WeatherResponseModel: Codable {
    var cod : String?
    var message : Double?
    var cnt : Int?
    var list : [WeatherModel]?
    var city : CityModel?
}

struct CityModel: Codable {
    var id : Int?
    var name : String?
    var coord : CoordinatesModel?
    var country : String?
    var population : Int?
}

struct CoordinatesModel: Codable {
    var lat : Double?
    var lon : Double?
}

struct WeatherResponseErrorModel: Codable {
    var cod : String?
    var message : String?
}
