import UIKit

enum WalletAction {
    case reloadWallets
    case reloadWallet(String)
    case reloadTransaction(String)
    
    case selectedWallet(String)
    case selectedTransaction(String)
}

enum WalletRoute {
    case walletDetail(WalletDetailViewProperties)
    case transactionDetail(TransactionDetailViewProperties)
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
    
    
    
    public var rootViewController: UIViewController {
        return self.navigationController
    }
    
    init() {
        self.navigationController.viewControllers = [walletViewController]
        walletViewController.dispatcher = self
        transactionDetailViewController.dispatcher = self
    }
    
    func dispatch(walletAction: WalletAction) {
        switch walletAction {
        case .reloadWallets: return
        case .reloadWallet(let walletAddress): return
        case .reloadTransaction(let transactionHash): return
        case .selectedTransaction(let transactionHash):
            handleRoute(route: .transactionDetail(DummyData.transacctionDetailProps))
        case .selectedWallet(let walletAddress):
            handleRoute(route: .walletDetail(DummyData.detailProperties))
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
        case .walletDetail(let walletDetailViewProperties):
            walletDetailViewController.properties = walletDetailViewProperties
            navigationController.pushViewController(walletDetailViewController, animated: true)
        case .wallets(let walletsViewProperties):
            walletViewController.properties = walletsViewProperties
            navigationController.pushViewController(walletViewController, animated: true)
        case .transactionDetail(let transactionDetailViewProperties):
            transactionDetailViewController.properties = transactionDetailViewProperties
            navigationController.pushViewController(transactionDetailViewController, animated: true)
        }
    }
}



