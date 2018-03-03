import UIKit
import Anchorage

final class WalletDetailHeaderView: UIView {
    fileprivate let background = UIImageView()
    fileprivate let balance = UILabel()
    fileprivate let received = UILabel()
    fileprivate let sent = UILabel()
    fileprivate let copyButton = PrimaryButton()
    fileprivate let qrButton = SecondaryButton()
    
    public var properties: WalletDetailHeaderViewProperties = .default {
        didSet {
            balance.text = properties.balance
            received.text = properties.received
            sent.text = properties.send
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = StyleConstants.navGray
        copyButton.setTitle("Copy Wallet Address", for: .normal)
        qrButton.setTitle("Show Wallet QR Code", for: .normal)
        
        let buttons: [UIView] = [qrButton, copyButton]
        
        buttons.forEach { button in
            button.heightAnchor == 40
        }
        
        let buttonStack = UIStackView(arrangedSubviews: buttons)
        buttonStack.spacing = 24
        
        let labels: [UILabel] = [balance, received, sent]
        
        labels.forEach { label in
            label.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        }
        
        let mainStack = UIStackView(arrangedSubviews: labels + [buttonStack])
        mainStack.axis = .vertical
        mainStack.spacing = 12
        addSubview(mainStack)
        mainStack.edgeAnchors == edgeAnchors + UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        
        copyButton.widthAnchor == qrButton.widthAnchor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

