import UIKit

final class MetadataTableSectionController: NSObject, TableSectionController {
    var sectionTitle: String?
    public var sections: [TableSectionController] = []
    
    func registerReusableTypes(tableView: UITableView) {
        tableView.register(MetadataRowItemCell.self, forCellReuseIdentifier: String(describing: MetadataRowItemCell.self))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].tableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].tableView(tableView, cellForRowAt: IndexPath(row: indexPath.row, section: 0))
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: WalletSectionHeader.self)) as? WalletSectionHeader else {
            return UIView()
        }
        header.title.text = sections[section].sectionTitle
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
//    static func mapControllerFromProperties(_ properties: MetadataSectionProperties) -> MetadataTableSectionController {
//        let controller = MetadataTableSectionController()
//        controller.properties = properties
//        return controller
//    }
}

final class MetadataTitleTableSectionController: NSObject, TableSectionController {
    public var properties: MetadataTitleSectionProperties = .default
    
    var sectionTitle: String? {
        get {
            return properties.title
        }
    }
    

    
    func registerReusableTypes(tableView: UITableView) {
        tableView.register(MetadataRowItemCell.self, forCellReuseIdentifier: String(describing: MetadataRowItemCell.self))
        tableView.register(WalletSectionHeader.self, forHeaderFooterViewReuseIdentifier: String(describing: WalletSectionHeader.self))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MetadataRowItemCell.self)) as? MetadataRowItemCell else {
            return UITableViewCell()
        }
        cell.properties = properties.items[indexPath.row]
        return cell
    }

    static func mapControllerFromProperties(_ properties: MetadataSectionProperties) -> MetadataTableSectionController {
        let controller = MetadataTableSectionController()
        controller.properties = properties
        return controller
    }
}

struct MetadataAddressSectionProperties: MetadataSectionProperties {
    let title: String
    let addresses: [String]
    static let `detail` = MetadataAddressSectionProperties(title: "", addresses: [])
}

final class MetadataAddressTableSectionController: NSObject, TableSectionController {
    public var addresses: [String] = []
    
    var sectionTitle: String? {
        get {
            return "Addresses"
        }
    }
    
    func registerReusableTypes(tableView: UITableView) {
        tableView.register(MetadataRowItemCell.self, forCellReuseIdentifier: String(describing: MetadataRowItemCell.self))
        tableView.register(WalletSectionHeader.self, forHeaderFooterViewReuseIdentifier: String(describing: WalletSectionHeader.self))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MetadataAddressRowItemCell.self)) as? MetadataAddressRowItemCell else {
            return UITableViewCell()
        }
        cell.address = addresses[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    static func mapControllerFromProperties(_ addresses: [String]) -> MetadataAddressTableSectionController {
        let controller = MetadataAddressTableSectionController()
        controller.addresses = addresses
        return controller
    }
}
