
import UIKit
import SVProgressHUD

class UIHelper: NSObject {

    static func showProgressHUD()
    {
        SVProgressHUD.show()
    }
    
    static func hideProgressHUD()
    {
        SVProgressHUD.dismiss()
    }
    
    static func showError(error: ErrorModel?)
    {
        
        if let error = error
        {
            self.showAlert(title: "Error", message: error.description)
        }
    }
    
    static func showAlert(_ target : UIViewController? = nil, title:String, message:String)
    {
        
        
        self.showAlert(target, title: title, message: message, buttons: ["Tamam"], style:.alert, alertHandler: nil)
    }
    
    
    static func showAlert(_ target : UIViewController? = nil, title:String?, message:String?, buttons:[String], style:UIAlertControllerStyle, alertHandler: ((_ alert:UIAlertController, _ desicion:Int) -> Void)?) {
        
        let alert = CustomAlertController(title: title, message: message, preferredStyle: style)
        
        alert.modalPresentationCapturesStatusBarAppearance = true
        alert.setNeedsStatusBarAppearanceUpdate()
        
        for item in buttons {
            let cancelButton = UIAlertAction(title: item, style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                alertHandler?(alert,buttons.index(of: item)!)
            })
            
            alert.addAction(cancelButton)
        }
        
        if style == .actionSheet
        {
            let cancelButton = UIAlertAction(title: "İptal", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) -> Void in
                alertHandler?(alert,buttons.count)
            })
            alert.addAction(cancelButton)
        }
        
        if target == nil
        {
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            alertWindow.makeKeyAndVisible()
            alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
        } else
        {
            target!.present(alert, animated: false, completion: nil)
        }
    }

}
