
import UIKit

protocol BaseTableViewCellDelegate : class {
    
    func baseTableViewCellActionIsTriggered(_ baseTableViewCell:BaseTableViewCell,actionName:String,info:AnyObject?)
}

class BaseTableViewCell: UITableViewCell {

    typealias BaseAction = () -> (Void)
    typealias BaseActionWithData = (Any) -> (Void)
    
    var cellData:Any?
    weak var delegate:BaseTableViewCellDelegate?
    
    static func dequeFrom<T>(tableView: UITableView, indexPath: IndexPath) -> T
    {
        return tableView.dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as! T
    }
    
    func refreshCellWithData(_ cellData:Any?)
    {
        self.cellData = cellData
    }
}
