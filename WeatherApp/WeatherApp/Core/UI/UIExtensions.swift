import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UITableView
{
    func autoDimensionWith(rowHeight: CGFloat)
    {
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = rowHeight
    }
    
    func autoDimension()
    {
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 20
    }
    
    func fullsize()
    {
        self.isScrollEnabled = true
        self.setHeightConstant(constant: 8000)
        self.reloadData()
        self.layoutIfNeeded()
        
        self.setHeightConstant(constant: Float(self.contentSize.height))
        self.reloadData()
        self.layoutIfNeeded()
        self.isScrollEnabled = false
    }
}

extension UIScrollView
{
    func cancelScrollAnimation()
    {
        let offset = self.contentOffset
        let fakeOffset = CGPoint(x: offset.x+1,y: offset.y+1)
        
        self.setContentOffset(fakeOffset, animated: false)
        self.setContentOffset(offset, animated: false)
    }
}

extension UIView {
    
    func getConstraintWithAttribute(attribute:NSLayoutAttribute) -> NSLayoutConstraint?
    {
        var targetView:UIView?
        
        if attribute == .width || attribute == .height
        {
            targetView = self
        }else
        {
            targetView = self.superview
        }
        
        for constraint:NSLayoutConstraint in targetView!.constraints
        {
            let firstItem:UIView? = constraint.firstItem as? UIView
            
            if firstItem != nil
            {
                if firstItem! == self
                {
                    if constraint.firstAttribute == attribute || constraint.secondAttribute == attribute
                    {
                        return constraint
                    }
                }
            }
            
        }
        
        return nil
    }
    
    func setConstantWithConstraintAttribute(constant:Float,attribute:NSLayoutAttribute)
    {
        let constraint:NSLayoutConstraint? = self.getConstraintWithAttribute(attribute: attribute)
        if constraint != nil
        {
            constraint!.constant = CGFloat(constant)
        }
    }
    
    func setLeftConstant(constant:Float)
    {
        self.setConstantWithConstraintAttribute(constant: constant,attribute: .left)
    }
    
    func setRightConstant(constant:Float)
    {
        self.setConstantWithConstraintAttribute(constant: constant,attribute: .right)
    }
    
    func setTopConstant(constant:Float)
    {
        self.setConstantWithConstraintAttribute(constant: constant,attribute: .top)
    }
    
    func setBottomConstant(constant:Float)
    {
        self.setConstantWithConstraintAttribute(constant: constant,attribute: .bottom)
    }
    
    func setLeadingConstant(constant:Float)
    {
        self.setConstantWithConstraintAttribute(constant: constant,attribute: .leading)
    }
    
    func setTrailingConstant(constant:Float)
    {
        self.setConstantWithConstraintAttribute(constant: constant,attribute: .trailing)
    }
    
    func setWidthConstant(constant:Float)
    {
        self.setConstantWithConstraintAttribute(constant: constant,attribute: .width)
    }
    
    func setHeightConstant(constant:Float)
    {
        self.setConstantWithConstraintAttribute(constant: constant,attribute: .height)
    }
    
    func setCenterXConstant(constant:Float)
    {
        self.setConstantWithConstraintAttribute(constant: constant,attribute: .centerX)
    }
    
    func setCenterYConstant(constant:Float)
    {
        self.setConstantWithConstraintAttribute(constant: constant,attribute: .centerY)
    }
    
    
    var x:CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var currentFrame = self.frame
            currentFrame.origin.x = newValue
            self.frame = currentFrame
        }
    }
    
    var y:CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var currentFrame = self.frame
            currentFrame.origin.y = newValue
            self.frame = currentFrame
        }
    }
    
    var width:CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var currentFrame = self.frame
            currentFrame.size.width = newValue
            self.frame = currentFrame
        }
    }
    
    var height:CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var currentFrame = self.frame
            currentFrame.size.height = newValue
            self.frame = currentFrame
        }
    }
    
    var bottom:CGFloat {
        get {
            return y + height
        }
    }
    
    var right:CGFloat {
        get {
            return x + width
        }
    }
    
    var centerX:CGFloat {
        get {
            return center.x
        }
    }
    
    var centerY:CGFloat {
        get {
            return center.y
        }
    }
    
    func addFullSizeSubview(view:UIView)
    {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(view)
        
        let leftConstraint = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        
        self.addConstraints([leftConstraint,topConstraint,rightConstraint,bottomConstraint])
    }
    
    func addFullSizeSnapToLeft(view:UIView)
    {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(view)
        
        let leftConstraint = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)

        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        
        self.addConstraints([leftConstraint,topConstraint,bottomConstraint])
    }
    
    func addFullSizeSnapToRight(view:UIView)
    {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(view)
        
        let leftConstraint = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        
        self.addConstraints([rightConstraint,topConstraint,bottomConstraint])
    }
    
    
    func addCenterSubviewWithFullWidth(view:UIView)
    {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(view)
        
        let centerX = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
        
        self.addConstraints([centerX,centerY,widthConstraint])
    }
    
    func addCenterSubviewWithTopAndWidth(view:UIView, offset:CGFloat = 0.0)
    {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(view)
        
        let centerX = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: offset)
        let widthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
        
        self.addConstraints([centerX,top,widthConstraint])
    }
    
    
    
    func addFullSizeWithWidthAndHeightSubview(view:UIView)
    {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(view)
        
        let leftConstraint = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
        
        self.addConstraints([leftConstraint,topConstraint,widthConstraint,heightConstraint])
    }
    
    
    
    func insertFullSizeSubview(view:UIView, atIndex:Int)
    {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.insertSubview(view, at: atIndex)
        
        let leftConstraint = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
        
        self.addConstraints([leftConstraint,topConstraint,widthConstraint,heightConstraint])
        
    }
}

extension UILabel
{
    func setHTMLFromString(htmlText: String)
    {
        var fixedHtmlText = htmlText
        
        if htmlText.hasPrefix("<p>") == true
        {
            fixedHtmlText = htmlText.substring(from: 3)
        }
        
        if fixedHtmlText.hasSuffix("</p>") == true
        {
            fixedHtmlText = fixedHtmlText.substring(to: fixedHtmlText.count - 4)
        }
        
        let modifiedFont = NSString(format:"<span style=\"color: white; font-family: \(self.font!.fontName); font-size: \(self.font!.pointSize)\">%@</span>" as NSString, fixedHtmlText) as String
        
//        let attrStr = try! NSAttributedString(
//            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
//            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//                      NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue,
//                      NSForegroundColorAttributeName: UIColor.white],
//            documentAttributes: nil)
        
        
        let attrStr = try! NSAttributedString(data: modifiedFont.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8], documentAttributes: nil)
        
        self.attributedText = attrStr
    }
}

extension UIScrollView
{
    func scrollToBottom(animated: Bool = true)
    {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}

extension UIView
{
    func rotate(radians: CGFloat)
    {
        self.transform = self.transform.rotated(by: radians)
    }
}



