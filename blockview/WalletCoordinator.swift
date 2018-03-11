import UIKit

enum WalletAction {
    case reloadWallets
    case reloadWallet(String)
    case selectedWallet(String)
    
    case reloadTransaction(String)
    case selectedTransaction(String)
    
    case reloadTransactionSegment(String)
    case selectedTransactionSegment(String)
    
    case displayWalletQR(String, String)
    case walletTypeSelectAlert
    case scanQR(WalletType)
    case deliverQRResult(String, WalletType?)
}

struct TransactionSegmentViewProperties {
    let title: String
    let sections: [MetadataSectionProperties]
    static let `default` = TransactionSegmentViewProperties(title: "", sections: [])
}


enum WalletRoute {
    case walletDetail(WalletDetailViewProperties)
    case transactionDetail(TransactionDetailViewProperties)
    case transactionSegmentDetail(TransactionSegmentViewProperties)
    case wallets(WalletsViewProperties)
    case qrCodeDisplay(String, String)
    case walletTypeSelectAlert
    case scanQRCode
}

protocol WalletActionDispatching: class {
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
    fileprivate let qrDisplayViewController = QRDispalyViewController()
    fileprivate let scannerViewController = ScannerViewController()
    fileprivate let walletTypeAlertController = UIAlertController(title: "Wallet Type", message: "Select your Wallet type.", preferredStyle: .actionSheet)
    
    public var rootViewController: UIViewController {
        return self.navigationController
    }
    
    init() {
        self.navigationController.viewControllers = [walletViewController]
        walletViewController.dispatcher = self
        walletDetailViewController.dispatcher = self
        transactionDetailViewController.dispatcher = self
        
        scannerViewController.success = { [weak self] address, walletType in
            self?.dispatch(walletAction: .deliverQRResult(address, walletType))
        }
        
        let walletTypes: [WalletType] = [.bitcoin, .litecoin, .dash, .dogecoin]
        
        self.addWalletSelectAlertActions(walletTypeAlertController, walletTypes: walletTypes)
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
            
        case .reloadTransactionSegment(let transactionSegmentAddress): return
        case .selectedTransactionSegment(let transactionSegmentAddress):
            handleRoute(route: .transactionSegmentDetail(TransactionSegmentViewProperties(title: "segment detail", sections: DummyData.transacctionDetailProps.sections)))
        
        
        case .displayWalletQR(let walletAddress, let walletTitle):
           handleRoute(route: .qrCodeDisplay(walletAddress, walletTitle))
        case .scanQR(let walletType):
            scannerViewController.walletType = walletType
            handleRoute(route: .scanQRCode)
            return
        case .deliverQRResult(let walletType, let walletAddress):
            print(walletType)
        
        case .walletTypeSelectAlert:
            handleRoute(route: .walletTypeSelectAlert)
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
        case .qrCodeDisplay(let walletAddress, let walletTitle):
            qrDisplayViewController.address = walletAddress
            qrDisplayViewController.title = walletTitle
            navigation?.present(UINavigationController(rootViewController: qrDisplayViewController), animated: true, completion: nil)
        case .walletTypeSelectAlert:
            navigation?.present(walletTypeAlertController, animated: true, completion: nil)
        case .scanQRCode:
            navigation?.present(scannerViewController, animated: true, completion: nil)
        }
    }
}

protocol WalletFactory {
    func makeWalletSelectorAlertController() -> UIAlertController
    func makeWalletSelectorAction(_ walletType: WalletType) -> UIAlertAction
    func addWalletSelectAlertActions(_ controller: UIAlertController, walletTypes: [WalletType])
}

extension WalletCoordinator: WalletFactory {
    func makeWalletSelectorAlertController() -> UIAlertController {
        let controller = UIAlertController(title: "Wallet Type", message: "Select your Wallet type.", preferredStyle: .actionSheet)
        let walletTypes: [WalletType] = [.bitcoin, .litecoin, .dash, .dogecoin]
        return controller
    }
    
    func addWalletSelectAlertActions(_ controller: UIAlertController, walletTypes: [WalletType]) {
        var actions: [UIAlertAction] = walletTypes.map(self.makeWalletSelectorAction(_:))
        actions.append(.cancel)
        
        actions.forEach { action in
            controller.addAction(action)
        }
    }
    
    func makeWalletSelectorAction(_ walletType: WalletType) -> UIAlertAction {
        return UIAlertAction(title: walletType.rawValue, style: .default, handler: { [weak self] _ in
            self?.dispatch(walletAction: .scanQR(walletType))
        })
    }
}

extension UIAlertAction {
    static let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
}


final class WalletService {
    
}
