import UIKit
import Lottie
import Anchorage

protocol WalletRowItemPropertiesUpdating {
    var properties: WalletRowProperties { get set }
    func update(_ properties: WalletRowProperties)
}

struct WalletsSectionProperties {
    let items: [WalletRowProperties]
    let title: String
}

struct WalletRowProperties {
    let name: String
    let address: String
    let holdings: String
    let spent: String
    let walletType: WalletType
    static let `default` = WalletRowProperties(name: "", address: "", holdings: "", spent: "", walletType: .bitcoin)
}

enum WalletType: String {
    case bitcoin
    case litecoin
    case dogecoin
    case dash
    
    public var icon: UIImage {
        switch self {
        case .bitcoin: return #imageLiteral(resourceName: "btc")
        case .litecoin: return #imageLiteral(resourceName: "litecoin")
        case .dash: return #imageLiteral(resourceName: "dash")
        case .dogecoin: return #imageLiteral(resourceName: "dogecoin")
        }
    }
    
    public var color: UIColor {
        switch self {
        case .bitcoin: return UIColor(red:0.97, green:0.58, blue:0.10, alpha:1.0)
        case .litecoin: return UIColor.gray
        case .dogecoin: return UIColor(red:0.76, green:0.65, blue:0.20, alpha:1.0)
        case .dash: return UIColor(red:0.22, green:0.45, blue:0.71, alpha:1.0)
        }
    }
    
    public var symbol: String {
        switch self {
        case .bitcoin: return "BTC"
        case .litecoin: return "LTC"
        case .dogecoin: return "DOGE"
        case .dash: return "DASH"
        }
    }
}

struct WalletsViewProperties {
    let title: String
    var sections: [WalletsSectionProperties]
    static let `default` = WalletsViewProperties(title: "", sections: [])
}

final class WalletsViewController: UIViewController {
    public weak var dispatcher: WalletActionDispatching?
    fileprivate let emptyState = WalletsEmptyStateView()
    fileprivate let table = UITableView()
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate let refreshControl = UIRefreshControl()
    fileprivate var isSearching: Bool = false
    
    public var properties: WalletsViewProperties = .default {
        didSet {
            
        }
    }
    
    let sections: [WalletsSectionProperties] = DummyData.sections
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Wallets"
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(table)
        table.backgroundView?.backgroundColor = .clear
        table.backgroundColor = .clear
        table.edgeAnchors == view.edgeAnchors
        table.estimatedRowHeight = UITableViewAutomaticDimension
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        table.register(WalletRowCell.self, forCellReuseIdentifier: String(describing: WalletRowCell.self))
        table.register(WalletSectionHeader.self, forHeaderFooterViewReuseIdentifier: String(describing: WalletSectionHeader.self))
        
//        view.addSubview(emptyState)
//        emptyState.edgeAnchors == view.edgeAnchors
//        emptyState.actionButton.addTarget(self, action: #selector(scanTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(scanTapped))
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.delegate = self
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            table.refreshControl = refreshControl
        } else {
            table.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        
        let actions = [
            UIAlertAction(title: "Bitcoin", style: .default, handler: { [weak self] _ in
//                self?.dispatcher?.dispatch(walletAction: .scanQR(.bitcoin))
            }),
            UIAlertAction(title: "Litecoin", style: .default, handler: { _ in
                
            }),
            UIAlertAction(title: "Dogecoin", style: .default, handler: { _ in
                
            }),
            UIAlertAction(title: "Dash", style: .default, handler: { _ in
                
            }),
            UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        ]
        
//        actions.forEach { action in walletTypeAlertController.addAction(action) }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let selected = table.indexPathForSelectedRow {
            table.deselectRow(at: selected, animated: true)
        }
    }
    
    @objc func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func scanTapped() {
        dispatcher?.dispatch(walletAction: .walletTypeSelectAlert)
//        present(walletTypeAlertController, animated: true, completion: nil)
        
        
//        present(ScannerViewController(), animated: true, completion: nil)
    }
    
    @objc func editTapped() {
        
    }
}

extension WalletsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension WalletsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
//        filteredCryptos = cryptos
//        let searchCryptos = filteredCryptos.filter { $0.name.uppercased().range(of: searchText.uppercased()) != nil  || $0.symbol.uppercased().range(of: searchText.uppercased()) != nil }
//        filteredCryptos = searchText == "" ? cryptos : searchCryptos
//        tableView.reloadData()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
//        view.sendSubview(toBack: searchEmptyStateView)
//        tableView.reloadData()
    }
}

extension WalletsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WalletRowCell.self)) as? WalletRowCell else {
            return UITableViewCell()
        }
        cell.properties = sections[indexPath.section].items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: WalletSectionHeader.self)) as? WalletSectionHeader else {
            return UIView()
        }
        header.title.text = sections[section].title
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WalletRowCell.self)) as? WalletRowCell {
            dispatcher?.dispatch(walletAction: .selectedWallet(cell.properties.address))
        }
//        let detailController = WalletDetailController()
//        detailController.properties = detailProperties
//        navigationController?.pushViewController(detailController, animated: true)
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Add") { (action, view, handler) in
            print("Add Action Tapped")
        }
        deleteAction.backgroundColor = StyleConstants.primaryGreen
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            print("Delete Action Tapped")
        }
        deleteAction.backgroundColor = StyleConstants.primaryRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

enum StyleConstants {
    static let primaryBlue: UIColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
    static let primaryGreen: UIColor = UIColor(red:0.16, green:0.73, blue:0.37, alpha:1.0)
    static let primaryRed: UIColor = UIColor(red:0.99, green:0.30, blue:0.33, alpha:1.0)
    static let navGray: UIColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
}



