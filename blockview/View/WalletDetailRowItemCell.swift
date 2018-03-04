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
        transactionBackground.backgroundColor = StyleConstants.primaryGreen
        transactionBackground.layer.cornerRadius = 21
        transactionBackground.leadingAnchor == contentView.leadingAnchor + 12
        transactionBackground.centerYAnchor == contentView.centerYAnchor
        transactionBackground.addSubview(transactionIcon)
        
        transactionIcon.image = #imageLiteral(resourceName: "up_arrow")
        transactionIcon.centerAnchors == transactionBackground.centerAnchors
        transactionIcon.sizeAnchors == CGSize(width: 20, height: 25)
        
        let stack = UIStackView(arrangedSubviews: [title, subTitle])
        stack.axis = .vertical
        stack.spacing = 6
        contentView.addSubview(stack)
        stack.leadingAnchor == transactionBackground.trailingAnchor + 12
        stack.verticalAnchors == contentView.verticalAnchors + 8
        
        title.text = "Sent 149.48672345 BTC"
        title.font = UIFont.systemFont(ofSize: 14)
        
        subTitle.text = "3:56 PM, June 29, 2019"
        subTitle.font = UIFont.systemFont(ofSize: 12)
        subTitle.textColor = .gray
        
        let lock = #imageLiteral(resourceName: "lock")
        lockIcon.image = lock.withRenderingMode(.alwaysTemplate)
        lockIcon.tintColor = StyleConstants.primaryGreen
        contentView.addSubview(lockIcon)
        lockIcon.sizeAnchors == CGSize(width: 32, height: 32)
        lockIcon.trailingAnchor == contentView.trailingAnchor - 12
        lockIcon.centerYAnchor == contentView.centerYAnchor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

