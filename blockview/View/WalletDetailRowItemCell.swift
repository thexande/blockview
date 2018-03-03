import UIKit
import Anchorage

final class WalletDetailRowItemCell: UITableViewCell {
    fileprivate let title = UILabel()
    fileprivate let subTitle = UILabel()
    fileprivate let transactionIcon = UIImageView()
    fileprivate let transactionBackground = UIView()
    fileprivate let lockIcon = UIImageView()
    fileprivate let confirmationCount = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(transactionBackground)
        transactionBackground.sizeAnchors == CGSize(width: 42, height: 42)
        transactionBackground.backgroundColor = .red
        transactionBackground.layer.cornerRadius = 21
        transactionBackground.leadingAnchor == contentView.leadingAnchor + 12
        transactionBackground.centerYAnchor == contentView.centerYAnchor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

