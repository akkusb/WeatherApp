import UIKit

class CustomAlertController: UIAlertController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        _ = self.prefersStatusBarHidden
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        _ = self.prefersStatusBarHidden
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        
        guard var targetViewController = presentingViewController else {
            return .lightContent
        }
        
        while let parentViewController = targetViewController.parent {
            targetViewController = parentViewController
        }
        
        while let childViewController = targetViewController.childViewControllerForStatusBarStyle {
            targetViewController = childViewController
        }
        
        return targetViewController.preferredStatusBarStyle
    }
    
    override var prefersStatusBarHidden : Bool {
        guard var targetViewController = presentingViewController else {
            return false
        }
        
        while let parentViewController = targetViewController.parent {
            targetViewController = parentViewController
        }
        
        while let childViewController = targetViewController.childViewControllerForStatusBarHidden {
            targetViewController = childViewController
        }
        
        return targetViewController.prefersStatusBarHidden
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
