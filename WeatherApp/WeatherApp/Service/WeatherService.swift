//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Burhan on 02/07/2018.
//  Copyright © 2018 Burhan. All rights reserved.
//

import UIKit
import Alamofire

class WeatherService: BaseService {

    static func getWeatherForecast(query: String, success:@escaping (_ weatherResponseModel:WeatherResponseModel?) -> Void, failure:@escaping (_ errorModel:ErrorModel?) -> Void) -> Void {

        if let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed){
            
            let urlString = baseUrl + "?q=" + encodedQuery + "&units=metric&APPID=" + appId
            BaseService.get(url: urlString, parameters: nil, success: { (responseData) in
                guard let baseResponse = responseData else{
                    failure(nil)
                    return
                }
                let decoder : JSONDecoder = JSONDecoder()
                do{
                    let weatherResponseModel : WeatherResponseModel = try decoder.decode(WeatherResponseModel.self, from: baseResponse)
                    success(weatherResponseModel)
                }
                catch{
                    do{
                        let weatherResponseErrorModel : WeatherResponseErrorModel = try decoder.decode(WeatherResponseErrorModel.self, from: baseResponse)
                        failure(ErrorModel.init(description: weatherResponseErrorModel.message ?? ""))
                        
                    }
                    catch{
                        
                        failure(ErrorModel())
                    }
                    
                }
                
            }) { (errorModel) in
                failure(errorModel)
            }
        }
        
        
        
//        var parameters : [String:Any] = [:]
//        parameters["q"] = query
//        parameters["units"] = "metric"
//        parameters["APPID"] = BaseService.appId
//
//        BaseService.get(url: BaseService.baseUrl, parameters: parameters, success: { (responseData) in
//            guard let baseResponse = responseData else{
//                failure(nil)
//                return
//            }
//            let decoder : JSONDecoder = JSONDecoder()
//            do{
//                let weatherResponseModel : WeatherResponseModel = try decoder.decode(WeatherResponseModel.self, from: baseResponse)
//                success(weatherResponseModel)
////
////                if weatherResponseModel.Success == true
////                {
////                    success(weatherResponseModel)
////                }else
////                {
////                    failure(ErrorModel(response: agreementResponse))
////                }
//            }
//            catch{
//                failure(ErrorModel())
//            }
//
//        }) { (errorModel) in
//            failure(errorModel)
//        }
    }
    
}
