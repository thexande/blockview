import UIKit
import Result
import Hydra

enum WalletAction {
    case reloadWallets
    case selectedWallet(String, WalletCurrency)
    case reloadTransaction(String)
    case reloadTransactionSegment(String)
    case selectedTransaction(String, WalletCurrency)

    case selectedTransactionSegment(String)
    case walletTypeSelectAlert
    case walletNameSelectAlert
    case displayDefaultWallets
    case displayWalletQR(String, String)
    case scanQR(WalletCurrency)
    case deliverQRResult(String, WalletCurrency?)
    case copyWalletAddressToClipboard(String)
    
    case selectedInput(Input)
    case selectedOutput(Output)
    
    enum Donation {
        case qr(DonationCurrency)
        case copyAddress(DonationCurrency)
    }
    case showDonate
    case donate(Donation)
    case presentDonationOptions(DonationCurrency)
    
    case dismissOnboarding
}




enum DonationCurrency {
    case btc
    case eth
    case ltc
    
    var title: String {
        switch self {
        case .btc: return "Bitcoin"
        case .eth: return "Ethereum"
        case .ltc: return "Litecoin"
        }
    }
    
    var address: String {
        switch self {
        case .btc: return "3J34NbtHR6YcV4aNDv9qCAEb96tujmZ2nH"
        case .eth: return "0x0cCB57a6617460Cf43fb6C1E00275803beD8aD0A"
        case .ltc: return "MP29JQrv4bXx6RoPZMtYimvEi8AmLZ2xyb"
        }
    }
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

enum WalletRoute {
    case walletDetail(String, WalletCurrency)
    case transactionDetail(String, WalletCurrency)
    case wallets(LoadableProps<WalletsViewProperties>)
    case qrCodeDisplay(String, String)
    case walletTypeSelectAlert
    case walletNameSelectAlert
    case scanQRCode
}

protocol WalletActionDispatching: class {
    func dispatch(_ action: WalletAction)
}

protocol WalletRoutable {
    func handleRoute(route: WalletRoute)
    var navigation: UINavigationController? { get }
}
//
//protocol WalletViewControllerProducing {
//    func makeWalletDetailViewController(presenter: WalletDetailPresenter) -> WalletDetailController
//}
//
//final class WalletViewControllerFactory: WalletViewControllerProducing {
//    func makeWalletDetailViewController(presenter: WalletDetailPresenter) -> WalletDetailController {
//        let vc = WalletDetailController()
//        vc.dispatcher = presenter
//        vc.deliver = { [weak presenter] props in
//
//        }
//    }
//}


final class WalletCoordinator {
    private var currentRoute: WalletRoute = .wallets(.data(.default))
    private var fetchedWallet: Wallet?
    private let factory = WalletControllerFactory()
    private let walletService: WalletService
    private let navigationController = UINavigationController(rootViewController: UIViewController())
    
    private let walletsViewController = WalletsViewController()
    private let walletPresenter: WalletsPresenter
    
    private let walletDetailPresenter = WalletDetailPresenter()
    
    private let transactionDetailPresenter = TransactionDetailPresenter()
    
    private let qrDisplayViewController = QRDispalyViewController()
    private let scannerViewController = ScannerViewController()
    private let donationController = DonateViewController()
    private let onboardingViewController = OnboardingInformationViewController()

    
    private let walletTypeAlertController = UIAlertController(
        title: "Wallet Type",
        message: "More wallet types coming soon!", // "Select your Wallet type.",
        preferredStyle: .actionSheet
    )
    
    private let walletNameAlertController = UIAlertController(
        title: "Wallet Name",
        message: "Select a name for your new wallet, or input a custom name.",
        preferredStyle: .actionSheet
    )
    
    public var rootViewController: UIViewController {
        return self.navigationController
    }
    
    private func makeWalletDetailViewController() -> WalletDetailController {
        let walletDetailViewController = WalletDetailController()
        walletDetailViewController.title = "Details"
        walletDetailPresenter.dispatcher = self
        walletDetailViewController.dispatcher = walletDetailPresenter
        walletDetailPresenter.deliver = { [weak self] props in
            walletDetailViewController.render(props)
        }
        return walletDetailViewController
    }
    
    private func makeTransactionDetailViewController() -> TransactionDetailViewController {
        let controller = TransactionDetailViewController()
        controller.dispatcher = transactionDetailPresenter
        controller.title = "Transaction"
        transactionDetailPresenter.deliver = { props in
            controller.render(props)
        }
        return controller
    }

    init() {
        let walletService = WalletService(session: URLSession.shared)
        self.walletService = walletService
        walletTypeAlertController.view.tintColor = StyleConstants.primaryPurple
        
        walletPresenter = WalletsPresenter(walletService: walletService)
        
        self.navigationController.viewControllers = [walletsViewController]
        walletsViewController.dispatcher = walletPresenter
        walletPresenter.deliver = { [weak self] props in
            self?.walletsViewController.properties = props
        }
        
        donationController.dispatcher = self

        walletPresenter.dispatcher = self
        transactionDetailPresenter.dispatch = self
        factory.dispatcher = self
        
        
        walletsViewController.properties = .data(WalletsViewProperties(title: "Wallets", sections: [], displayLoading: false))
        
        scannerViewController.success = { [weak self] address, walletType in
            self?.dispatch(.deliverQRResult(address, walletType))
        }
        
        let walletTypes: [WalletCurrency] = [.bitcoin] //, .litecoin, .dash, .dogecoin]
        
        factory.addWalletSelectAlertActions(walletTypeAlertController, walletTypes: walletTypes)
        factory.addWalletNameAlertActions(walletNameAlertController, walletDescriptions: WalletDescription.props)
        
        navigationController.navigationBar.prefersLargeTitles = true
        
        
        // Onboarding
        onboardingViewController.dispatcher = self
        
        if (UserDefaults.standard.object(forKey: "has_seen_onboarding") == nil) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                if let controller = self?.onboardingViewController {
                    controller.modalTransitionStyle = .crossDissolve
                    self?.navigationController.present(controller, animated: true, completion: {
                        UserDefaults.standard.set(true, forKey: "has_seen_onboarding")
                    })
                }
            }
        }
    }
}

struct CryptoWallet {
    let wallet: Wallet
    let currency: WalletCurrency
}


extension WalletService {
    func wallet(address: String, type: WalletCurrency) -> Promise<Wallet> {
        return Promise<Wallet>(in: .background, { [weak self] resolve, reject, _  in
            guard let `self` = self else {
                reject(WalletServiceError.walletDoesNotExist)
                return
            }
            
            self.wallet(address: address, currency: type, completion: { result in
                switch result {
                case let .success(data): resolve(data)
                case let .failure(error): reject(error)
                }
            })
        })
    }
}

extension WalletCoordinator: WalletActionDispatching {
    func dispatch(_ action: WalletAction) {
        switch action {
        case let .selectedTransaction(hash, currency):
            handleRoute(route: .transactionDetail(hash, currency))
            
        case .selectedWallet(let walletAddress, let walletType):
            handleRoute(route: .walletDetail(walletAddress, walletType))
            
        case .reloadTransaction(let transactionHash): return
        case let .selectedTransaction(transactionHash, walletCurrency):
            handleRoute(route: .transactionDetail(transactionHash, walletCurrency))
            
        case .reloadTransactionSegment(let transactionSegmentAddress): return
            
            
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
            
        case let .selectedInput(input):
            handleInputSelect(input)
        case let .selectedOutput(output):
            handleOutputSelect(output)
           
        case .showDonate:
            navigationController.present(donationController, animated: true, completion: nil)
        case let .donate(donation):
            handleDonation(donation)
        case let .presentDonationOptions(currency):
            handleCurrency(currency)
        case .dismissOnboarding:
            onboardingViewController.dismiss(animated: true, completion: nil)
        default: return
        }
    }
    
    private func handleInputSelect(_ input: Input) {
        let controller = TransactionSegmentDetailViewController()
        controller.title = "Input"
        controller.render(TransactionSegmentDetailViewController.Properties(input))
        navigation?.pushViewController(controller, animated: true)
    }
    
    private func handleOutputSelect(_ output: Output) {
        let controller = TransactionSegmentDetailViewController()
        controller.title = "Output"
        controller.render(TransactionSegmentDetailViewController.Properties(output))
        navigation?.pushViewController(controller, animated: true)
    }
}

/// Coordinator Action Handling Extension
extension WalletCoordinator {
    private func handleCopyWalletAddressToClipboard(walletAddress: String) {
        UIPasteboard.general.string = walletAddress
        let alert = UIAlertController.confirmationAlert(
            confirmationTitle: "Copied.",
            confirmationMessage: "Wallet address \(walletAddress) has been copied to your clipboard."
        )
        navigation?.present(alert, animated: true, completion: nil)
    }
    
    private func handleQRResult(walletAddress: String, walletType: WalletCurrency?) {
        guard let walletType = walletType else {
            return
        }
        
        walletDetailPresenter.properties = .loading
        
        DispatchQueue.main.async {
            let controller = self.makeWalletDetailViewController()
            self.navigation?.pushViewController(controller, animated: true)
        }
        
        walletService.wallet(address: walletAddress, currency: walletType) { [weak self] walletResult in
            switch walletResult {
            case .success(let wallet):
                self?.fetchedWallet = wallet
                self?.walletDetailPresenter.wallet = wallet
                var props = Wallet.recentWalletDetailViewProperties(wallet)
                props.headerProperties.backgroundImage = walletType.icon
//                self?.handleRoute(route: .wallet)
                self?.walletDetailPresenter.properties = .data(props)
                self?.walletDetailPresenter.cryptoWallet = (walletAddress, walletType)
                
            case .failure(let error):
                print(error.localizedDescription)
                let alertController = UIAlertController(
                    title: "Oops.",
                    message:  String(
                        format: "We could not find a wallet with that address on the %@ blockchain.",
                        walletType.rawValue.capitalized
                    ),
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "ok", style: .default, handler: { [weak self] _ in
                    DispatchQueue.main.async {
                        self?.navigation?.popViewController(animated: true)
                    }
                }))
                
                DispatchQueue.main.async {
                    self?.navigation?.present(alertController, animated: true, completion: nil)
                }
            }
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
        case .walletDetail(let address, let walletType):
            
            walletDetailPresenter.cryptoWallet = (address, walletType)
            DispatchQueue.main.async { [weak self] in
                guard let controller = self?.makeWalletDetailViewController() else { return }
                self?.navigation?.pushViewController(controller, animated: true)
            }
        case .wallets(let properties):
            if navigation?.viewControllers.contains(walletsViewController) ?? false {
                walletPresenter.loaableProperties = properties
                return
            }
            
            walletPresenter.loaableProperties = properties
            navigation?.pushViewController(walletsViewController, animated: true)
            
        case let .transactionDetail(hash, currency):
            transactionDetailPresenter.loadTransaction(hash: hash, currency: currency)
            let controller = makeTransactionDetailViewController()
            navigation?.pushViewController(controller, animated: true)
            
            
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


extension WalletCoordinator {
    private func handleCurrency(_ currency: DonationCurrency) {
        let alert = makeDonateActionSheet(for: currency)
        donationController.present(alert, animated: true, completion: nil)
    }
    
    private func handleDonation(_ donation: WalletAction.Donation) {
        switch donation {
        case let .copyAddress(currency):
            UIPasteboard.general.string = currency.address
            let alert = UIAlertController.confirmationAlert(
                confirmationTitle: "Copied.",
                confirmationMessage: "Wallet address \(currency.address) has been copied to your clipboard."
            )
            donationController.present(alert, animated: true, completion: nil)

        case let .qr(currency):
            qrDisplayViewController.currency = currency
            donationController.present(UINavigationController(rootViewController: qrDisplayViewController), animated: true, completion: nil)
        }
    }

    private func makeDonateActionSheet(for currency: DonationCurrency) -> UIAlertController {
        let alert = UIAlertController(title: "Thanks for wanting to help!",
                                      message: "You can either copy my \(currency.title) wallet address, or scan my wallet's QR Code.",
            preferredStyle: .actionSheet)
        
        let copyAction = UIAlertAction(title: "Copy my \(currency.title) address", style: .default) { [weak self] _ in
            self?.dispatch(.donate(.copyAddress(currency)))
        }
        
        let qrAction = UIAlertAction(title: "Display my \(currency.title) wallet QR code", style: .default) { [weak self] _ in
            self?.dispatch(.donate(.qr(currency)))
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        [copyAction, qrAction, cancelAction].forEach { action in
            alert.addAction(action)
        }
        
        return alert
    }
}
