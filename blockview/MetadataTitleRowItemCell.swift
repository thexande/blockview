import UIKit
import Anchorage

final class MetadataTitleRowItemCell: UITableViewCell, ViewPropertiesUpdating {
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    
    var properties: MetadataTitleRowItemProperties = .default {
        didSet {
            render(properties)
        }
    }
    
    func render(_ properties: MetadataTitleRowItemProperties) {
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
            label.font = UIFont.systemFont(ofSize: 16)
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
    private let addressLabel = UILabel()
    
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
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class MetadataTransactionSegmentRowItemCell: UITableViewCell {
    private let addressLabel = UILabel()
    
    public var address: String? {
        didSet {
            addressLabel.text = address
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        addressLabel.numberOfLines = 0
        addressLabel.textColor = .gray
        addressLabel.font = UIFont.systemFont(ofSize: 12)
        
        contentView.addSubview(addressLabel)
        
        addressLabel.verticalAnchors == contentView.verticalAnchors + 12
        addressLabel.horizontalAnchors == contentView.horizontalAnchors + 12
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


final class ActionIconRowCell: UITableViewCell {
    let titleLabel = UILabel()
    let icon = UIImageView()

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var iconImage: UIImage? {
        didSet {
            icon.image = iconImage
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        icon.heightAnchor == icon.widthAnchor
        icon.heightAnchor == 24
        icon.contentMode = .scaleAspectFit
        let stack = UIStackView(arrangedSubviews: [icon, titleLabel])
        stack.spacing = 18
        contentView.addSubview(stack)
        stack.edgeAnchors == contentView.edgeAnchors + UIEdgeInsets(top: 12, left: 18, bottom: 12, right: 18)
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
