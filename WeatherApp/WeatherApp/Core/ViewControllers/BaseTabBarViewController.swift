
import UIKit

class BaseTabBarViewController: UITabBarController {

    override var selectedViewController: UIViewController? {
        didSet {
            
            guard let viewControllers = viewControllers else {
                return
            }
            
            for viewController in viewControllers {
                

            
            }
        }
    }
}
