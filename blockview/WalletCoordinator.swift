import UIKit

enum WalletAction {
    case reloadWallets
    case reloadWallet(String)
    case reloadTransaction(String)
    case routeToWalletDetail(String)
}

enum WalletRoute {
    case walletDetail(WalletDetailViewProperties)
    case wallets(WalletsViewProperties)
}

protocol WalletActionDispatching {
    func dispatch(walletAction: WalletAction)
}

protocol WalletRouter {
    func handleRoute(route: WalletRoute)
}

final class WalletCoordinator: WalletActionDispatching, WalletRouter {
    fileprivate let navigationController = UINavigationController(rootViewController: UIViewController())
    fileprivate let walletViewController = WalletsViewController()
    fileprivate let walletDetailViewController = WalletDetailController()
    
    public var rootViewController: UIViewController {
        return self.navigationController
    }
    
    init() {
        self.navigationController.viewControllers = [walletViewController]
        walletViewController.dispatch = self
    }
    
    func dispatch(walletAction: WalletAction) {
        switch walletAction {
        case .reloadWallets: return
        case .reloadWallet(let walletAddress): return
        case .reloadTransaction(let transactionHash): return
        case .routeToWalletDetail(let walletAddress): return
        
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
        }
    }
}
