
import UIKit
import SVProgressHUD
import TPKeyboardAvoiding
import ScrollTo

protocol BaseViewControllerDelegate: class
{
    func baseViewControllerActionIsTriggered(_ baseViewController:BaseViewController,actionName:String,info:AnyObject?)
}

class BaseViewController: UIViewController,BaseViewControllerDelegate,BaseTableViewCellDelegate,BaseCollectionViewCellDelegate,UIGestureRecognizerDelegate
{

    @IBOutlet weak var keyboardAvoidingScrollView: TPKeyboardAvoidingScrollView?
    @IBOutlet weak var confirmButtonHeightConstraint: NSLayoutConstraint?
    @IBOutlet weak var confirmButtonBottomConstraint: NSLayoutConstraint?
    var isButtonOverKeyboardEnabled = false{
        didSet{
            if isButtonOverKeyboardEnabled {
                if  self.confirmButtonBottomConstraint != nil {
                    NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameWillChange), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
                    if let scrollView = self.keyboardAvoidingScrollView{
                        scrollView.contentInset.bottom += self.confirmButtonHeightConstraint?.constant ?? 0
                        scrollView.tpKeyboardAvoiding_updateContentInset()
                    }
                }
                else{
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
                }
            }
            else{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
            }
        }
    }
    
    
    typealias ButtonAction = () -> (Void)
    typealias BaseAction = () -> (Void)
    typealias BaseActionWithData = (AnyObject) -> (Void)
    
    var firstViewWillAppear:Bool = true
    var firstViewDidAppear:Bool = true
    var firstViewDidLayoutSubviews:Bool = true

    weak var delegate:BaseViewControllerDelegate?
    
    func baseViewControllerActionIsTriggered(_ baseViewController:BaseViewController,actionName:String,info:AnyObject?) {}
    func baseTableViewCellActionIsTriggered(_ baseTableViewCell:BaseTableViewCell,actionName:String,info:AnyObject?) {}
    func baseCollectionViewCellActionIsTriggered(_ baseTableViewCell:BaseCollectionViewCell,actionName:String,info:AnyObject?) {}
    
    func viewWillAppearFirst(_ animated: Bool) {}
    func viewDidAppearFirst(_ animated: Bool) {}
    func viewDidLayoutSubviewsFirst() {}

    var isRightUtilityButtonsShown = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        if self.navigationController != nil
        {
            self.navigationController!.navigationBar.isTranslucent = false;
//            self.edgesForExtendedLayout = UIRectEdge()
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        self.initialize()
    }
    
    deinit {
        if self.isButtonOverKeyboardEnabled {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        }
    }
    
    func initialize() -> Void
    {
        
    }
    
    func showHudBlockingInteraction()
    {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
    }
    
    func showHud()
    {
//        SVProgressHUD.setOffsetFromCenter(UIOffsetMake(0, 0))
        SVProgressHUD.show()
    }
    
    func hideHud()
    {
        SVProgressHUD.dismiss()
        SVProgressHUD.setDefaultMaskType(.none)
    }
    
  
    func setNavigationBarSetTitle(title:String) -> Void
    {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 100, height: 38))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 100, height: 38))
        titleLabel.textAlignment = .center
        titleLabel.text = title
        titleView.clipsToBounds = false
        let heightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 38)
        titleView.addFullSizeSubview(view: titleLabel)
        titleLabel.addConstraint(heightConstraint)
        self.navigationItem.titleView = titleView
//        titleView.layoutIfNeeded()
//        titleLabel.font = Constants.AtasunOrgonExtraLightFont(size: 17)
    }
    
    func setNavigationBarSetTitleImage(image:String) -> Void {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: image)
        imageView.image = image
        
        self.navigationItem.titleView = imageView
    }

    func setNavigationBarBackground(color : UIColor) -> Void {
        
        
        self.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            
            self.navigationController?.navigationBar.barTintColor = color
            
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            
        })
        
    }
    

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        if firstViewWillAppear == true
        {
            firstViewWillAppear = false
            self.viewWillAppearFirst(animated)
        }

//        if self.navigationController != nil
//        {
//            self.navigationController!.navigationBar.isTranslucent = false;
//            self.edgesForExtendedLayout = UIRectEdge();
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.hideHud()
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if firstViewDidAppear == true
        {
            firstViewDidAppear = false
            self.viewDidAppearFirst(animated)
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        if self.firstViewDidLayoutSubviews == true
        {
            self.firstViewDidLayoutSubviews = false
            self.viewDidLayoutSubviewsFirst()
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    func changeTabBar(hidden:Bool, animated: Bool){
        
        if let tabBar = self.tabBarController?.tabBar {
            if tabBar.isHidden == hidden{ return }
            let frame = tabBar.frame
            let offset = (hidden ? (frame.size.height) : -(frame.size.height))
            let duration:TimeInterval = (animated ? 0.3 : 0.0)
            tabBar.isHidden = false
            
            UIView.animate(withDuration: duration,
                           animations: {
                            tabBar.frame = frame.offsetBy(dx: 0, dy: offset)
                            
            },
                           completion: {
//                            print($0)
                            if $0 {
                                tabBar.isHidden = hidden
                                
                            }
            })
        }
        
    }
    
    @objc func popViewController()
    {
        DispatchQueue.main.async {
            
            if self.navigationController != nil
            {
                self.view.endEditing(true)
                self.navigationController!.popViewController(animated: true)
            }
            
        }
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)? = nil)
    {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    @objc func dismissViewController()
    {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func getViewControllerFromMainStoryboard<T>(_ viewControllerId:String) -> T
    {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewControllerId) as! T
    }
    
    func getViewControllerFromStoryboard<T>(_ viewControllerId:String, storyboardName:String) -> T
    {
        return UIStoryboard.init(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: viewControllerId) as! T
    }
    
    static func getViewControllerFromMainStoryboard<T>(_ viewControllerId:String) -> T
    {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewControllerId) as! T
    }
    
    static func getViewControllerFromStoryboard<T>(_ viewControllerId:String, storyboardName:String) -> T
    {
        return UIStoryboard.init(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: viewControllerId) as! T
    }
    
    @objc func languageDidChange() {}
    
//    func addPullToRefresh(tableView:UITableView, refresh:@escaping () -> Void) -> Void {
//        tableView.addSubview(self.refreshControl)
//    }
    
    func addPullToRefresh(tableView:UITableView) -> Void {
        tableView.addSubview(self.refreshControl)
    }
    func addPullToRefresh(collectionView:UICollectionView) -> Void {
        collectionView.addSubview(self.refreshControl)
    }
    func addPullToRefresh(scrollView:UIScrollView) -> Void {
        scrollView.addSubview(self.refreshControl)
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    @objc func pullToRefresh(_ refreshControl: UIRefreshControl) -> Void {
        self.pullToRefresh()
        refreshControl.endRefreshing()
    }
    
    func pullToRefresh() -> Void {
        
    }

    @objc func keyboardFrameWillChange(notification: NSNotification)
    {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.confirmButtonBottomConstraint?.constant = 0.0
            } else {
                
                self.confirmButtonBottomConstraint?.constant = endFrame?.size.height ?? 0.0
                self.confirmButtonBottomConstraint?.constant -= self.getBottomSafeAreaInset()
                if !self.hidesBottomBarWhenPushed{
                    self.confirmButtonBottomConstraint?.constant -= self.tabBarController?.tabBar.height ?? 0
                }
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    func getBottomSafeAreaInset() -> CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
//            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
            return bottomPadding ?? 0
        }
        else{
            return 0
        }
    }

}
