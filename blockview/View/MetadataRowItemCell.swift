import UIKit
import Anchorage

final class MetadataTitleRowItemCell: UITableViewCell, ViewPropertiesUpdating {
    fileprivate let titleLabel = UILabel()
    fileprivate let contentLabel = UILabel()
    
    public var properties: MetadataTitleRowItemProperties = .default {
        didSet {
            update(properties)
        }
    }
    
    func update(_ properties: MetadataTitleRowItemProperties) {
        titleLabel.text = properties.title
        contentLabel.text = properties.content
        
        if properties.content.count < 60 {
            contentLabel.textAlignment = .right
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let labels = [titleLabel, contentLabel]
        contentLabel.textColor = .gray
        
        labels.forEach { label in
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 14)
        }
        
        let stack = UIStackView(arrangedSubviews: labels)
        stack.spacing = 12
        contentView.addSubview(stack)
        let inset: CGFloat = 12
        stack.edgeAnchors == contentView.edgeAnchors + UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        
        titleLabel.widthAnchor == contentView.widthAnchor * 0.3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class MetadataAddressRowItemCell: UITableViewCell {
    fileprivate let addressLabel = UILabel()
    
    public var address: String? {
        didSet {
            addressLabel.text = address
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let inset: CGFloat = 12
        addressLabel.numberOfLines = 0
        addressLabel.textColor = .gray
        addressLabel.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(addressLabel)
        addressLabel.edgeAnchors == contentView.edgeAnchors + UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class MetadataTransactionSegmentRowItemCell: UITableViewCell {
    fileprivate let rightIcon = UIImageView(image: #imageLiteral(resourceName: "Arrow Right"))
    fileprivate let addressLabel = UILabel()
    
    public var address: String? {
        didSet {
            addressLabel.text = address
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addressLabel.numberOfLines = 0
        addressLabel.textColor = .gray
        addressLabel.font = UIFont.systemFont(ofSize: 16)
        
        contentView.addSubview(addressLabel)
        contentView.addSubview(rightIcon)
        
        addressLabel.verticalAnchors == contentView.verticalAnchors + 12
        addressLabel.leadingAnchor == contentView.leadingAnchor + 12
        addressLabel.trailingAnchor == rightIcon.leadingAnchor - 12
        
        rightIcon.sizeAnchors == CGSize(width: 8, height: 13)
        rightIcon.centerYAnchor == contentView.centerYAnchor
        rightIcon.trailingAnchor == contentView.trailingAnchor - 12
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
