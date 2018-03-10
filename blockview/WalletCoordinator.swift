import UIKit

enum WalletAction {
    case reloadWallets
    case reloadWallet(String)
    case reloadTransaction(String)
    
    case selectedWallet(String)
    case selectedTransaction(String)
    case selectedTransactionSegment(String)
}

struct TransactionSegmentViewProperties {
    let title: String
    let items: [MetadataRowItemProperties]
    static let `default` = TransactionSegmentViewProperties(title: "", items: [])
}


enum WalletRoute {
    case walletDetail(WalletDetailViewProperties)
    case transactionDetail(TransactionDetailViewProperties)
    case transactionSegmentDetail(TransactionSegmentViewProperties)
    case wallets(WalletsViewProperties)
}

protocol WalletActionDispatching {
    func dispatch(walletAction: WalletAction)
}

protocol WalletRoutable {
    func handleRoute(route: WalletRoute)
    weak var navigation: UINavigationController? { get }
}

final class WalletCoordinator: WalletActionDispatching {
    fileprivate let navigationController = UINavigationController(rootViewController: UIViewController())
    fileprivate let walletViewController = WalletsViewController()
    fileprivate let walletDetailViewController = WalletDetailController()
    fileprivate let transactionDetailViewController = TransactionDetailViewController()
    fileprivate let transactionSegmentDetailViewController = TransactionSegmentViewController()
    
    
    
    public var rootViewController: UIViewController {
        return self.navigationController
    }
    
    init() {
        self.navigationController.viewControllers = [walletViewController]
        walletViewController.dispatcher = self
        walletDetailViewController.dispatcher = self
        transactionDetailViewController.dispatcher = self
    }
    
    func dispatch(walletAction: WalletAction) {
        switch walletAction {
        case .reloadWallets: return
        case .reloadWallet(let walletAddress): return
        case .selectedWallet(let walletAddress):
            handleRoute(route: .walletDetail(DummyData.detailProperties))
        case .reloadTransaction(let transactionHash): return
        case .selectedTransaction(let transactionHash):
            handleRoute(route: .transactionDetail(DummyData.transacctionDetailProps))
        case .selectedTransactionSegment(let transactionSegmentAddress):
            handleRoute(route: .transactionSegmentDetail(.default))
        }
    }
}

extension WalletCoordinator: WalletRoutable {
    var navigation: UINavigationController? {
        get {
            return self.navigationController
        }
    }
    
    func handleRoute(route: WalletRoute) {
        switch route {
        case .walletDetail(let properties):
            walletDetailViewController.properties = properties
            navigation?.pushViewController(walletDetailViewController, animated: true)
        case .wallets(let properties):
            walletViewController.properties = properties
            navigation?.pushViewController(walletViewController, animated: true)
        case .transactionDetail(let properties):
            transactionDetailViewController.properties = properties
            navigation?.pushViewController(transactionDetailViewController, animated: true)
        case .transactionSegmentDetail(let properties):
            transactionSegmentDetailViewController.properties = properties
            navigation?.pushViewController(transactionSegmentDetailViewController, animated: true)
        }
    }
}



