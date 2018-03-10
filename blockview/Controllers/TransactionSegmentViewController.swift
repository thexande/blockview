import UIKit

final class TransactionSegmentViewController: UITableViewController, ViewPropertiesUpdating {
    typealias ViewProperties = TransactionSegmentViewProperties
    public var properties: TransactionSegmentViewProperties = .default {
        didSet {
            update(properties)
        }
    }
    
    func update(_ properties: TransactionSegmentViewProperties) {
        
    }
}
