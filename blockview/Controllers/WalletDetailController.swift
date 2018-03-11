import UIKit
import Anchorage

protocol ViewPropertiesUpdating {
    associatedtype ViewProperties
    var properties: ViewProperties { get set }
    func update(_ properties: ViewProperties)
}

enum WalletDetailRowType {
    case sent
    case recieved
}

struct WalletDetailViewProperties {
    let title: String
    let headerProperties: WalletDetailHeaderViewProperties
    let items: [TransactionRowItemProperties]
    static let `default` = WalletDetailViewProperties(title: "", headerProperties: WalletDetailHeaderViewProperties(balance: "", received: "", send: "", address: "", title: ""), items: [])
}

struct WalletDetailHeaderViewProperties {
    let balance: String
    let received: String
    let send: String
    let address: String
    let title: String
    static let `default` = WalletDetailHeaderViewProperties(balance: "", received: "", send: "", address: "", title: "")
}

struct TransactionRowItemProperties {
    let transactionHash: String
    let transactionType: WalletDetailRowType
    let title: String
    let subTitle: String
    let confirmationCount: String
    static let `default` = TransactionRowItemProperties(transactionHash: "", transactionType: .sent, title: "", subTitle: "", confirmationCount: "")
}

final class WalletDetailController: SectionProxyTableViewController, ViewPropertiesUpdating {
    fileprivate let header = WalletDetailHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 172))
    fileprivate let segment = UISegmentedControl(items: [ "Recent", "Largest"])
    
    public weak var dispatcher: WalletActionDispatching? {
        didSet {
            header.dispatcher = dispatcher
        }
    }
    
    override var sections: [TableSectionController] {
        didSet {
            sections.forEach { $0.registerReusableTypes(tableView: tableView) }
            tableView.reloadData()
        }
    }
    
    public var properties: WalletDetailViewProperties = .default {
        didSet {
            update(properties)
        }
    }
    
    func update(_ properties: WalletDetailViewProperties) {
        header.properties = properties.headerProperties
        title = properties.title
        header.properties = properties.headerProperties
        let controller = TransactionTableSectionController.mapController(from: properties.items)
        controller.dispatcher = dispatcher
        sections = [controller]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(pressedSave   ))
        
        navigationItem.titleView = segment
        tableView.tableHeaderView = header
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        segment.sizeToFit()
        segment.addTarget(self, action: #selector(didChangeSegmentedControl(_:)), for: .valueChanged)
        segment.selectedSegmentIndex = 0
        navigationItem.titleView = segment
        
        tableView.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.refreshControl?.endRefreshing()
        }
    }

    @objc func didChangeSegmentedControl(_ sender: UISegmentedControl) {
        
    }
    
    @objc func pressedSave() {
        dispatcher?.dispatch(walletAction: .walletNameSelectAlert)
    }
}
