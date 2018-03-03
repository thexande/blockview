import UIKit
import Lottie
import Anchorage

struct MyWalletsSectionProperties {
    let items: [WalletRowProperties]
    let title: String
}

protocol WalletRowItemPropertiesUpdating {
    var properties: WalletRowProperties { get set }
    func update(_ properties: WalletRowProperties)
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
}

final class MyWalletsViewController: UIViewController {
    let emptyState = MyWalletsEmptyStateView()
    let table = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    fileprivate let refreshControl = UIRefreshControl()
    var isSearching: Bool = false

    
    var sections: [MyWalletsSectionProperties] = [
        MyWalletsSectionProperties(items: [
                WalletRowProperties(name: "Coinbase", address: "Lb3sAACgGk8i6GsMApKqpTi2DWoybaU5BV", holdings: "Holding: 0.87999823 BTC", spent: "Spent: 0.87999823 BTC", walletType: .bitcoin),
            ], title: "Bitcoin"),
        MyWalletsSectionProperties(items: [
            WalletRowProperties(name: "Coinbase", address: "Lb3sAACgGk8i6GsMApKqpTi2DWoybaU5BV", holdings: "Holding: 0.87999823 BTC", spent: "Spent: 0.87999823 BTC", walletType: .litecoin),
            WalletRowProperties(name: "Coinbase", address: "Lb3sAACgGk8i6GsMApKqpTi2DWoybaU5BV", holdings: "Holding: 0.87999823 BTC", spent: "Spent: 0.87999823 BTC", walletType: .litecoin),
            ], title: "Litecoin"),
        
        MyWalletsSectionProperties(items: [
            WalletRowProperties(name: "Coinbase", address: "Lb3sAACgGk8i6GsMApKqpTi2DWoybaU5BV", holdings: "Holding: 0.87999823 BTC", spent: "Spent: 0.87999823 BTC", walletType: .dash),
            WalletRowProperties(name: "Coinbase", address: "Lb3sAACgGk8i6GsMApKqpTi2DWoybaU5BV", holdings: "Holding: 0.87999823 BTC", spent: "Spent: 0.87999823 BTC", walletType: .dash)
            ], title: "Dash"),
        
        MyWalletsSectionProperties(items: [
            WalletRowProperties(name: "Coinbase", address: "Lb3sAACgGk8i6GsMApKqpTi2DWoybaU5BV", holdings: "Holding: 0.87999823 BTC", spent: "Spent: 0.87999823 BTC", walletType: .dogecoin),
            WalletRowProperties(name: "Coinbase", address: "Lb3sAACgGk8i6GsMApKqpTi2DWoybaU5BV", holdings: "Holding: 0.87999823 BTC", spent: "Spent: 0.87999823 BTC", walletType: .dogecoin)
            ], title: "Dogecoin"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Wallets"
        
        
        view.addSubview(table)
        table.edgeAnchors == view.edgeAnchors
        table.estimatedRowHeight = UITableViewAutomaticDimension
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        table.register(WalletRowCell.self, forCellReuseIdentifier: String(describing: WalletRowCell.self))
        table.register(WalletSectionHeader.self, forHeaderFooterViewReuseIdentifier: String(describing: WalletSectionHeader.self))
        table.reloadData()
        
        
//        view.addSubview(emptyState)
//        emptyState.edgeAnchors == view.edgeAnchors
//        emptyState.actionButton.addTarget(self, action: #selector(scanTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "scan_title"), style: .plain, target: self, action: #selector(scanTapped))
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Currencies"
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
    }
    
    @objc func refreshData() {
        
    }
    
    @objc func scanTapped() {
        present(ScannerViewController(), animated: true, completion: nil)
    }
}

extension MyWalletsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension MyWalletsViewController: UISearchBarDelegate {
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

extension MyWalletsViewController: UITableViewDelegate, UITableViewDataSource {
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
}







