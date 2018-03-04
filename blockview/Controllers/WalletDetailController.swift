import UIKit
import Anchorage

enum WalletDetailRowType {
    case sent
    case recieved
}

struct WalletDetailViewProperties {
    let title: String
    let headerProperties: WalletDetailHeaderViewProperties
    let items: [WalletDetailRowItemProperties]
    static let `default` = WalletDetailViewProperties(title: "", headerProperties: WalletDetailHeaderViewProperties(balance: "", received: "", send: "", address: ""), items: [])
}

struct WalletDetailHeaderViewProperties {
    let balance: String
    let received: String
    let send: String
    let address: String
    static let `default` = WalletDetailHeaderViewProperties(balance: "", received: "", send: "", address: "")
}

struct WalletDetailRowItemProperties {
    let transactionType: WalletDetailRowType
    let title: String
    let subTitle: String
    let transactionCount: String
    static let `default` = WalletDetailRowItemProperties(transactionType: .sent, title: "", subTitle: "", transactionCount: "")
}

final class WalletDetailController: UITableViewController {
    fileprivate let header = WalletDetailHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 172))
    fileprivate let segment = UISegmentedControl(items: [ "Recent", "Largest"])
    
    public var properties: WalletDetailViewProperties = .default {
        didSet {
            title = properties.title
            header.properties = properties.headerProperties
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = segment
        tableView.tableHeaderView = header
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(WalletDetailRowItemCell.self, forCellReuseIdentifier: String(describing: WalletDetailRowItemCell.self))
        
        segment.sizeToFit()
        segment.addTarget(self, action: #selector(didChangeSegmentedControl(_:)), for: .valueChanged)
        segment.selectedSegmentIndex = 0
        navigationItem.titleView = segment
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WalletDetailRowItemCell.self), for: indexPath) as? WalletDetailRowItemCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    
    @objc func didChangeSegmentedControl(_ sender: UISegmentedControl) {
        
    }
}
