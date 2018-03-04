import UIKit
import Anchorage

final class WalletDetailHeaderView: UIView {
    fileprivate let background = UIImageView()
    fileprivate let balance = UILabel()
    fileprivate let balanceTitle = UILabel()
    fileprivate let received = UILabel()
    fileprivate let receivedTitle = UILabel()
    fileprivate let sent = UILabel()
    fileprivate let sentTitle = UILabel()
    fileprivate let copyButton = PrimaryButton()
    fileprivate let qrButton = SecondaryButton()
    fileprivate let accentImageView = UIImageView(image: #imageLiteral(resourceName: "btc"))
    
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
        clipsToBounds = true
        addSubview(accentImageView)
        accentImageView.alpha = 0.2
        copyButton.setTitle("Copy Wallet Address", for: .normal)
        qrButton.setTitle("Show Wallet QR Code", for: .normal)
        
        let buttons: [UIView] = [qrButton, copyButton]
        
        buttons.forEach { button in
            button.heightAnchor == 40
        }
        
        let buttonStack = UIStackView(arrangedSubviews: buttons)
        buttonStack.spacing = 12
        
        let labels: [UILabel] = [balance, received, sent, balanceTitle, receivedTitle, balanceTitle, sentTitle]
        [balance, received, sent].forEach { $0.textAlignment = .right }
        balanceTitle.text = "Balance"
        receivedTitle.text = "Received"
        sentTitle.text = "Sent"
        
        labels.forEach { label in
            label.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        }
        
        let labelStacks = [
            UIStackView(arrangedSubviews: [balanceTitle, balance]),
            UIStackView(arrangedSubviews: [receivedTitle, received]),
            UIStackView(arrangedSubviews: [sentTitle, sent])
        ]
        
        let mainStack = UIStackView(arrangedSubviews: labelStacks + [buttonStack])
        mainStack.axis = .vertical
        mainStack.spacing = 12
        addSubview(mainStack)
        mainStack.edgeAnchors == edgeAnchors + UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        copyButton.widthAnchor == qrButton.widthAnchor
        
        accentImageView.sizeAnchors == CGSize(width: 350, height: 350)
        accentImageView.centerXAnchor == trailingAnchor - 50
        accentImageView.centerYAnchor == bottomAnchor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

