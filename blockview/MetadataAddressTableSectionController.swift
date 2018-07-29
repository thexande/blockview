import UIKit
import Anchorage

final class MetadataAddressTableSectionController: NSObject, WalletTableSectionController {
    public var dispatcher: WalletDetailActionDispatching?
    public var properties: [MetadataAddressRowItemProperties] = []
    var sectionTitle: String?
    
    func registerReusableTypes(tableView: UITableView) {
        tableView.register(MetadataAddressRowItemCell.self, forCellReuseIdentifier: String(describing: MetadataAddressRowItemCell.self))
        tableView.register(WalletSectionHeader.self, forHeaderFooterViewReuseIdentifier: String(describing: WalletSectionHeader.self))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MetadataAddressRowItemCell.self)) as? MetadataAddressRowItemCell else {
            return UITableViewCell()
        }
        cell.address = properties[indexPath.row].address
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: WalletSectionHeader.self)) as? WalletSectionHeader else {
            return UIView()
        }
        header.textLabel?.text = sectionTitle
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dispatcher?.dispatch(.selectedTransactionSegment(properties[indexPath.row].address))
    }
    
    static func mapControllerFromProperties(_ properties: [MetadataAddressRowItemProperties]) -> MetadataAddressTableSectionController {
        let controller = MetadataAddressTableSectionController()
        controller.properties = properties
        return controller
    }
}


struct WalletDescriptionSectionProperties {
    let name: String
    let address: String
    let icon: UIImage?
    
    static let `default` = WalletDescriptionSectionProperties(name: "", address: "", icon: UIImage())
}

final class WalletDescriptionTableSectionController: NSObject, WalletTableSectionController {
    var dispatcher: WalletDetailActionDispatching?
    public var properties: WalletDescriptionSectionProperties = .default
    var sectionTitle: String?
    
    func registerReusableTypes(tableView: UITableView) {
        tableView.register(WalletDescriptionRowCell.self, forCellReuseIdentifier: String(describing: WalletDescriptionRowCell.self))
        tableView.register(WalletSectionHeader.self, forHeaderFooterViewReuseIdentifier: String(describing: WalletSectionHeader.self))

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WalletDescriptionRowCell.self)) as? WalletDescriptionRowCell else {
            return UITableViewCell()
        }
        cell.properties = properties
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: WalletSectionHeader.self)) as? WalletSectionHeader else {
            return UIView()
        }
        header.textLabel?.text = sectionTitle
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
}


final class WalletDescriptionRowCell: UITableViewCell {
    private let icon = UIImageView()
    private let title = UILabel()
    private let address = UILabel()
    
    public var properties: WalletDescriptionSectionProperties = .default {
        didSet {
            update(properties)
        }
    }
    
    func update(_ properties: WalletDescriptionSectionProperties) {
        title.text = properties.name
        address.text = properties.address
        icon.image = properties.icon
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackLabels = [title, address]
        stackLabels.forEach { $0.numberOfLines = 0 }
        
        let labelStack = UIStackView(arrangedSubviews: stackLabels)
        labelStack.axis = .vertical
        labelStack.spacing = 6
        
        contentView.addSubview(labelStack)
        contentView.addSubview(icon)
        
        labelStack.centerYAnchor == icon.centerYAnchor
        labelStack.trailingAnchor == contentView.trailingAnchor - 12
        labelStack.leadingAnchor == icon.trailingAnchor + 12
        
        icon.sizeAnchors == CGSize(width: 56, height: 56)
        labelStack.verticalAnchors == contentView.verticalAnchors + 18
        icon.leadingAnchor == contentView.leadingAnchor + 12
        icon.centerYAnchor == labelStack.centerYAnchor
        
        separatorInset = UIEdgeInsets(top: 0, left: 92, bottom: 0, right: 0)
        
        title.font = UIFont.systemFont(ofSize: 20)
        address.font = UIFont.systemFont(ofSize: 12)
        address.textColor = .darkGray
        
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
