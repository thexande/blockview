import UIKit

enum WalletAction {
    case reloadWallets
    case reloadWallet(String)
    case selectedWallet(String)
    case reloadTransaction(String)
    case selectedTransaction(String)
    case reloadTransactionSegment(String)
    case selectedTransactionSegment(String)
    case walletTypeSelectAlert
    case walletNameSelectAlert
    case displayWalletQR(String, String)
    case scanQR(WalletType)
    case deliverQRResult(String, WalletType?)
    case copyWalletAddressToClipboard(String)
}

enum WalletDescription {
    case coinbase
    case exodusWallet
    case coldStorage
    case ledgerNano
    case trezor
    
    public var title: String {
        switch self {
        case .coinbase: return "Coinbase"
        case .exodusWallet: return "Exodus"
        case .coldStorage: return "Cold Storage"
        case .ledgerNano: return "Ledger Nano"
        case .trezor: return "Trezor"
        }
    }
    
    static let props: [WalletDescription] = [.coinbase, .exodusWallet, .coldStorage, .ledgerNano, .trezor]
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
    case walletNameSelectAlert
    case scanQRCode
}

protocol WalletActionDispatching: class {
    func dispatch(walletAction: WalletAction)
}

protocol WalletRoutable {
    func handleRoute(route: WalletRoute)
    weak var navigation: UINavigationController? { get }
}

protocol WalletFactory {
    func makeWalletSelectorAlertController() -> UIAlertController
    func makeWalletSelectorAction(_ walletType: WalletType) -> UIAlertAction
    func addWalletSelectAlertActions(_ controller: UIAlertController, walletTypes: [WalletType])
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
    fileprivate let walletNameAlertController = UIAlertController(title: "Wallet Name", message: "Select a name for your new wallet, or input a custom name.", preferredStyle: .actionSheet)
    
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
        self.addWalletNameAlertActions(walletNameAlertController, walletDescriptions: WalletDescription.props)
        
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
        case .deliverQRResult(let walletAddress, let walletType):
            handleQRResult(walletAddress: walletAddress, walletType: walletType)
        case .walletTypeSelectAlert:
            handleRoute(route: .walletTypeSelectAlert)
        case .copyWalletAddressToClipboard(let walletAddress):
            handleCopyWalletAddressToClipboard(walletAddress: walletAddress)
        case .walletNameSelectAlert:
            handleRoute(route: .walletNameSelectAlert)
        }
    }
}

/// Coordinator Action Handling Extension
extension WalletCoordinator {
    fileprivate func handleCopyWalletAddressToClipboard(walletAddress: String) {
        let alert = UIAlertController.confirmationAlert(
            confirmationTitle: "Coppied.",
            confirmationMessage: "Wallet address \(walletAddress) has been coppied to your clipboard."
        )
        navigation?.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func handleQRResult(walletAddress: String, walletType: WalletType?) {
        guard let walletType = walletType else { return }
        WalletService.fetchWallet(walletAddress: walletAddress, walletType: walletType) { [weak self] wallet in
            guard let wallet = wallet else {
                let alertController = UIAlertController.confirmationAlert(
                    confirmationTitle: "Sorry.",
                    confirmationMessage: String(
                        format: "We could not find a wallet with that address on the %@ blockchain.",
                        walletType.rawValue.capitalized
                    )
                )
                DispatchQueue.main.async {
                    self?.navigation?.present(alertController, animated: true, completion: nil)
                }
                return
            }
            
            print(wallet)
        }
    }
}

extension UIAlertController {
    static func confirmationAlert(confirmationTitle: String, confirmationMessage: String) -> UIAlertController {
        let alertController = UIAlertController(title: confirmationTitle, message: confirmationMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alertController
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
        case .walletNameSelectAlert:
            navigation?.present(walletNameAlertController, animated: true, completion: nil)
        }
    }
}

extension WalletCoordinator: WalletFactory {
    func makeWalletSelectorAlertController() -> UIAlertController {
        let controller = UIAlertController(title: "Wallet Type", message: "Select your Wallet type.", preferredStyle: .actionSheet)
        let walletTypes: [WalletType] = [.bitcoin, .litecoin, .dash, .dogecoin]
        return controller
    }
    
    func addWalletSelectAlertActions(_ controller: UIAlertController, walletTypes: [WalletType]) {
        var actions: [UIAlertAction] = walletTypes.map(self.makeWalletSelectorAction(_:))
        actions.append(.cancel())
        
        actions.forEach { action in
            controller.addAction(action)
        }
    }
    
    func addWalletNameAlertActions(_ controller: UIAlertController, walletDescriptions: [WalletDescription]) {
        var actions: [UIAlertAction] = walletDescriptions.map(self.makeWalletNameSelectorAction(_:))
        actions.append(.cancel())
        
        actions.forEach { action in
            controller.addAction(action)
        }
    }
    
    func makeWalletSelectorAction(_ walletType: WalletType) -> UIAlertAction {
        return UIAlertAction(title: walletType.rawValue.capitalized, style: .default, handler: { [weak self] _ in
            self?.dispatch(walletAction: .scanQR(walletType))
        })
    }
    
    func makeWalletNameSelectorAction(_ walletName: WalletDescription) -> UIAlertAction {
        return UIAlertAction(title: walletName.title, style: .default, handler: { [weak self] _ in
//            self?.dispatch(walletAction: .scanQR(walletType))
        })
    }
}

extension UIAlertAction {
    static func cancel() -> UIAlertAction {
        return UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    }
}


final class WalletService {
    static func fetchWallet(walletAddress: String, walletType: WalletType, _ completion: @escaping(Wallet?) -> Void) {
        guard let url = URLFactory.url(walletAddress: walletAddress, walletType: walletType) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let wallet = try JSONDecoder().decode(Wallet.self, from: data)
                completion(wallet)
            } catch let error {
                completion(nil)
                print(error.localizedDescription)
            }
        }.resume()
    }
}


struct URLFactory {
    static func url(walletAddress: String, walletType: WalletType) -> URL? {
        let address = "https://api.blockcypher.com/v1/\(walletType.symbol.lowercased())/main/addrs/\(walletAddress)/full?limit=50"
        return URL(string: address)
    }
}

struct Wallet: Codable {
    let address: String
    let total_received: Int
    let total_sent: Int
    let balance: Int
    let unconfirmed_balance: Int
    let final_balance: Int
    let n_tx: Int
    let unconfirmed_n_tx: Int
    let final_n_tx: Int
    let txs: [Transaction]
}

struct Transaction: Codable {
    let block_hash: String
    let block_height: Int
    let block_index: Int
    let hash: String
    let addresses: [String]
    let total: Int
    let fees: Int
    let size: Int
    let preference: String
    let relayed_by: String?
    let confirmed: String
    let received: String
    let ver: Int
    let double_spend: Bool
    let vin_sz: Int
    let vout_sz: Int
    let confirmations: Int
    let confidence: Int
    let inputs: [Input]
    let outputs: [Output]
    
    static func viewPropertyItem(from transaction: Transaction) -> TransactionRowItemProperties {
        return TransactionRowItemProperties(
            transactionHash: transaction.hash,
            transactionType: .recieved,
            title: <#T##String#>,
            subTitle: <#T##String#>,
            confirmationCount: String(transaction.confirmations)
        )
    }
}

struct Input: Codable {
    let prev_hash: String
    let output_index: Int
    let output_value: Int
    let script_type: String
    let script: String
    let addresses: [String]
    let sequence: Int
    let age: Int
    let wallet_name: String?
    let wallet_token: String?
}

struct Output: Codable {
    let value: Int
    let script: String
    let addresses: [String]
    let script_type: String
    let spent_by: String?
    let data_hex: String?
    let data_string: String?
}
