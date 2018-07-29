import Foundation

enum WalletDetailAcitons {
    enum WalletDetailSortOrder {
        case recent
        case largest
    }
    
    enum Context {
        enum TransactionContext {
            case input
            case output
        }
        
        case wallet
        case transaction(TransactionContext)
    }
    
    case sortWalletDetail(WalletDetailSortOrder)
    case showMoreTransactions
    case reloadWallet(String, WalletCurrency)
    case selectedTransaction(String)
    case displayWalletQR
    case copyWalletAddressToClipboard
    case selectedTransactionSegment(String)
    case walletNameSelectAlert
    case selectedInput(String)
    case selectedOutput(String)
    case reloadTransaction(String)
}

protocol WalletDetailActionDispatching: AnyObject {
    func dispatch(_ action: WalletDetailAcitons)
}

final class WalletDetailPresenter: WalletDetailActionDispatching {
    weak var dispatcher: WalletActionDispatching?
    private let walletService = WalletService(session: URLSession.shared)
    var wallet: Wallet?
    var deliver: ((LoadableProps<WalletDetailViewProperties>) -> Void)?
    private var numberOfTransactions: Int = 30
    
    var properties: LoadableProps<WalletDetailViewProperties> = .loading {
        didSet {
            deliver?(properties)
        }
    }
    
    private var dataProperties: WalletDetailViewProperties = .default {
        didSet {
            properties = .data(dataProperties)
        }
    }
    
    var cryptoWallet: (String, WalletCurrency)? {
        didSet {
            if let wallet = cryptoWallet {
                properties = .loading
                reloadWallet(walletAddress: wallet.0, walletType: wallet.1)
            }
        }
    }
    
    private func reloadWallet(walletAddress: String, walletType: WalletCurrency) {
        dataProperties.showNavLoader = true
        walletService.wallet(address: walletAddress,
                             currency: walletType) { [weak self] walletResult in
            switch walletResult {
            case .success(let wallet):
                var walletProps = Wallet.recentWalletDetailViewProperties(wallet)
              
                if let icon = self?.cryptoWallet?.1.icon {
                    walletProps.headerProperties.backgroundImage = icon
                }
                
                self?.wallet = wallet
                self?.dataProperties = walletProps
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    self?.dataProperties.showNavLoader = false
                })
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func dispatch(_ action: WalletDetailAcitons) {
        switch action {
        case let .selectedTransaction(hash):
            if let wallet = cryptoWallet {
                dispatcher?.dispatch(.selectedTransaction(hash, wallet.1))
            }
        case .sortWalletDetail(let sortOrder):
            switch sortOrder {
            case .largest:
                if let wallet = wallet {
                    self.properties = .data(Wallet.largestWalletDetailViewProperties(wallet))
                }
            case .recent:
                if let wallet = wallet {
                    self.properties = .data(Wallet.recentWalletDetailViewProperties(wallet))
                }
            }
        case .reloadWallet(let wallet, let type): return
            reloadWallet(walletAddress: wallet,
                         walletType: type)
        case .showMoreTransactions: return
        case .displayWalletQR:
            if let cryptoWallet = cryptoWallet, case let .data(properties) = properties {
                dispatcher?.dispatch(.displayWalletQR(cryptoWallet.0, properties.title))
            }
        case .copyWalletAddressToClipboard:
            if let cryptoWallet = cryptoWallet {
                dispatcher?.dispatch(.copyWalletAddressToClipboard(cryptoWallet.0))
            }
            
        default: return //dispatcher?.dispatch(action)
        }
    }
}
