
import UIKit
import Alamofire

class BaseService: NSObject {
    //Base Url
    static let baseUrl : String = "http://api.openweathermap.org/data/2.5/forecast"
    static let appId : String = "8827fbf408dc7e1418f3c1e84596334c"

    static func get(url:URLConvertible, parameters:Parameters?, success:@escaping (_ responseData:Data?) throws -> Void, failure:@escaping (_ err:ErrorModel?) -> Void) -> Void {
        self.get(url: url, parameters: parameters, encoding: JSONEncoding.default, headers: nil, success:success, failure:failure)
    }
    
    static func get(url:URLConvertible, parameters:Parameters?, encoding:ParameterEncoding, headers:HTTPHeaders?, withoutRefreshToken:Bool, success:@escaping (_ responseData:Data?) throws -> Void, failure:@escaping (_ err:ErrorModel?) -> Void) -> Void{
        var h : HTTPHeaders? = headers
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: encoding, headers: h).responseData { (response) in
            response.result.ifSuccess {
                
                if response.response?.statusCode == 401
                {
                    failure(ErrorModel.init(description: "Unauthorized"))
                    
                    
                    
                }else
                {
                    let responseData : Data? = response.result.value
                    do{
                        try success(responseData)
                    }
                    catch{
                        
                    }
                    
                }
                
            }
            response.result.ifFailure {
                
                failure(ErrorModel(error: response.result.error))
            }
            
            }.responseJSON { (responseJSON) in
//                print("JSON")
        }
    }
    
    static func get(url:URLConvertible, parameters:Parameters?, encoding:ParameterEncoding, headers:HTTPHeaders?, success:@escaping (_ responseData:Data?) throws -> Void, failure:@escaping (_ err:ErrorModel?) -> Void) -> Void {
        get(url: url, parameters: parameters, encoding: encoding, headers: headers, withoutRefreshToken: false, success: success, failure: failure)
    }
    
    static func post(url:URLConvertible, parameters:Parameters?, success:@escaping (_ responseData:Data?) -> Void, failure:@escaping (_ err:ErrorModel?) -> Void) -> Void {
        self.post(url: url, parameters: parameters, encoding: JSONEncoding.default, headers: nil, success:success, failure:failure)
    }
    
    static func post(url:URLConvertible, parameters:Parameters?, encoding:ParameterEncoding, headers:HTTPHeaders?, success:@escaping (_ responseData:Data?) -> Void, failure:@escaping (_ err:ErrorModel?) -> Void) -> Void  {
        
        var h : HTTPHeaders? = headers
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: encoding, headers: h).responseData { (response) in
            response.result.ifSuccess {
                
                let responseData : Data? = response.result.value
                success(responseData)

            }
            response.result.ifFailure {
                
                failure(ErrorModel(error: response.result.error))
            }
            
            }.responseJSON { (responseJSON) in
//                print(responseJSON)
        }
    }
    
    
    static func postWithoutAuth(url:URLConvertible, parameters:Parameters?, encoding:ParameterEncoding, headers:HTTPHeaders?, success:@escaping (_ responseData:Data?) -> Void, failure:@escaping (_ err:ErrorModel?) -> Void) -> Void  {
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: encoding, headers: headers).responseData { (response) in
            response.result.ifSuccess {
                let responseData : Data? = response.result.value
                success(responseData)
            }
            response.result.ifFailure {
                
                failure(ErrorModel(error: response.result.error))
            }
            
            }.responseJSON { (responseJSON) in
//                print(responseJSON)
        }
    }

}
