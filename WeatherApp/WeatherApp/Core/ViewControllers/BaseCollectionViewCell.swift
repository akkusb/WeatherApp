
import UIKit

protocol BaseCollectionViewCellDelegate : class {
    
    func baseCollectionViewCellActionIsTriggered(_ baseTableViewCell:BaseCollectionViewCell,actionName:String,info:AnyObject?)
}

class BaseCollectionViewCell: UICollectionViewCell {
    
    typealias BaseAction = () -> (Void)
    typealias BaseActionWithData = (Any) -> (Void)
    
    var cellData:Any?
    weak var delegate:BaseCollectionViewCellDelegate?
    
    static func dequeFrom<T>(collectionView: UICollectionView, indexPath: IndexPath) -> T
    {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "\(T.self)", for: indexPath) as! T
    }
    
    func refreshCellWithData(_ cellData:Any?)
    {
        self.cellData = cellData
    }
}
