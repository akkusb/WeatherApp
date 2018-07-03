
import UIKit

class ErrorModel
{
    var description:String = "Bir Hata Oluştu"
    
    init(){}

    
    init(response: BaseResponse )
    {
        self.description = response.Message
    }
    
    init(error: Error?)
    {
        if let error = error
        {
            self.description = error.localizedDescription
        }
    }
    
    init(description: String )
    {
        self.description = description
    }
}
