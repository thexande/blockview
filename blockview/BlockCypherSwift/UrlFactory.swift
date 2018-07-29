import Foundation

public final class UrlFactory {
    public enum UrlError: Error {
        case urlGenerationError
    }
    
    func url(walletAddress: String,
             currency: WalletCurrency,
             limit: Int = 200) -> URL? {
        let address = "https://api.blockcypher.com/v1/\(currency.symbol.lowercased())/main/addrs/\(walletAddress)/full?limit=\(limit)"
        return URL(string: address)
    }
    
    func url(transactionHash: String,
                    currency: WalletCurrency,
                    limit: Int = 50) -> URL? {
        let address = "https://api.blockcypher.com/v1/\(currency.symbol.lowercased())/main/txs/\(transactionHash)?limit=\(limit)&includeHex=true"
        return URL(string: address)
    }
}
