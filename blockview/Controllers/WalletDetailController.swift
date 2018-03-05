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
    static let `default` = WalletDetailViewProperties(title: "", headerProperties: WalletDetailHeaderViewProperties(balance: "", received: "", send: "", address: ""), items: [])
}

struct WalletDetailHeaderViewProperties {
    let balance: String
    let received: String
    let send: String
    let address: String
    static let `default` = WalletDetailHeaderViewProperties(balance: "", received: "", send: "", address: "")
}

struct TransactionRowItemProperties {
    let transactionType: WalletDetailRowType
    let title: String
    let subTitle: String
    let confirmationCount: String
    static let `default` = TransactionRowItemProperties(transactionType: .sent, title: "", subTitle: "", confirmationCount: "")
}

final class WalletDetailController: UITableViewController, ViewPropertiesUpdating {
    fileprivate let header = WalletDetailHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 172))
    fileprivate let segment = UISegmentedControl(items: [ "Recent", "Largest"])
    
    fileprivate var sections: [TableSectionController] = [] {
        didSet {
            sections.forEach { $0.registerReusableTypes(tableView: tableView) }
            tableView.reloadData()
        }
    }
    
    let transacctionDetailProps = TransactionDetailViewProperties(
        title: "Outgoing LTC",
        transactionItemProperties:  TransactionRowItemProperties(transactionType: .sent, title: "Sent 149.48672345 LTC", subTitle: "3:56 PM, June 29, 2019", confirmationCount: "6+"),
        sections: [
            MetadataSectionProperties(title: "Transaction Metadata", items: [
                MetadataRowItemProperties(title: "Hash", content: "5be6b54c89d5be512f099914f52725b77b7c8168fc6e16c2d1b5dc8842576a67", displayStyle: .metadata),
                    MetadataRowItemProperties(title: "Block Index", content: "58", displayStyle: .metadata),
                    MetadataRowItemProperties(title: "Block Height", content: "19823129038", displayStyle: .metadata),
                    MetadataRowItemProperties(title: "Confirmations", content: "123", displayStyle: .metadata),
//                    MetadataRowItemProperties(title: "", content: ""),
//                    MetadataRowItemProperties(title: "", content: ""),
//                    MetadataRowItemProperties(title: "", content: ""),
                ]
            ),
            MetadataSectionProperties(title: "Transaction Metadata", items: [
                MetadataRowItemProperties(title: "Hash", content: "5be6b54c89d5be512f099914f52725b77b7c8168fc6e16c2d1b5dc8842576a67", displayStyle: .metadata),
                MetadataRowItemProperties(title: "Hash", content: "5be6b54c89d5be512f099914f52725b77b7c8168fc6e16c2d1b5dc8842576a67", displayStyle: .metadata),
                ]
            )
        ]
    )
    
    public var properties: WalletDetailViewProperties = .default {
        didSet {
            update(properties)
        }
    }
    
    func update(_ properties: WalletDetailViewProperties) {
        header.properties = properties.headerProperties
        title = properties.title
        header.properties = properties.headerProperties
        
        sections = [TransactionTableSectionController.mapController(from: properties.items)]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.titleView = segment
        tableView.tableHeaderView = header
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        segment.sizeToFit()
        segment.addTarget(self, action: #selector(didChangeSegmentedControl(_:)), for: .valueChanged)
        segment.selectedSegmentIndex = 0
        navigationItem.titleView = segment
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = TransactionDetailViewController()
        controller.properties = transacctionDetailProps
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func didChangeSegmentedControl(_ sender: UISegmentedControl) {
        
    }
}
