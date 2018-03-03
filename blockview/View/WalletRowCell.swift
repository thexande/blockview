import UIKit
import Anchorage

final class WalletRowCell: UITableViewCell, WalletRowItemPropertiesUpdating {
    fileprivate let icon = UIImageView()
    fileprivate let title = UILabel()
    fileprivate let address = UILabel()
    fileprivate let holding = UILabel()
    fileprivate let spent = UILabel()
    
    public var properties: WalletRowProperties = .default {
        didSet {
            update(properties)
        }
    }
    
    func update(_ properties: WalletRowProperties) {
        title.text = properties.name
        address.text = properties.address
        holding.text = properties.holdings
        holding.textColor = properties.walletType.color
        spent.text = properties.spent
        spent.textColor = properties.walletType.color
        icon.image = properties.walletType.icon
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackLabels = [title, address, holding, spent]
        stackLabels.forEach { label in label.numberOfLines = 0 }
        
        let labelStack = UIStackView(arrangedSubviews: stackLabels)
        labelStack.axis = .vertical
        labelStack.spacing = 6
        
        contentView.addSubview(labelStack)
        contentView.addSubview(icon)
        
        labelStack.verticalAnchors == contentView.verticalAnchors + 6
        labelStack.trailingAnchor == contentView.trailingAnchor - 12
        labelStack.leadingAnchor == icon.trailingAnchor + 12
        
        icon.sizeAnchors == CGSize(width: 56, height: 56)
        icon.centerYAnchor == contentView.centerYAnchor
        icon.leadingAnchor == contentView.leadingAnchor + 12
        
        title.font = UIFont.systemFont(ofSize: 20)
        address.font = UIFont.systemFont(ofSize: 12)
        address.textColor = .gray
        
        holding.font = UIFont.systemFont(ofSize: 12)
        
        spent.font = UIFont.systemFont(ofSize: 12)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
