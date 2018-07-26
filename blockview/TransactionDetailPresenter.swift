import Result

final class TransactionDetailPresenter: WalletDetailActionDispatching {
    var deliver: ((LoadableProps<TransactionDetailViewProperties>) -> Void)?
    let walletService = WalletService(session: URLSession.shared)
    var currency: WalletCurrency?
    weak var dispatch: WalletActionDispatching?
    
    private var transaction: Transaction? {
        didSet {
            if let transaction = transaction {
                properties = .data(TransactionDetailViewProperties(transaction))
            }
        }
    }
    
    var properties: LoadableProps<TransactionDetailViewProperties> = .loading {
        didSet {
            deliver?(properties)
        }
    }
    
    func loadTransaction(hash: String, currency: WalletCurrency) {
        walletService.transaction(hash: hash, currency: currency) { result in
            switch result {
            case let .success(transaction):
                self.transaction = transaction
            case let .failure(error): return
            }
        }
    }
    
    func dispatch(_ action: WalletDetailAcitons) {
        switch action {
        case let .reloadTransaction(hash):
            reloadTransaction(hash: hash)
        case let .selectedInput(identifier):
            handleSelectedInput(identifier)
        default: return
        }
    }
    
    private func handleSelectedInput(_ identifier: String) {
        guard let input = transaction?.inputs.first(where: { $0.script == identifier }) else {
            return
        }
        
        dispatch?.dispatch(.selectedInput(input))
    }
    
    private func reloadTransaction(hash: String) {
        guard let currency = currency else {
            return
        }
        
        loadTransaction(hash: hash, currency: currency)
    }
}
