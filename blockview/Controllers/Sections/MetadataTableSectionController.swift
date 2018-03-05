import UIKit

final class MetadataTableSectionController: NSObject, TableSectionController {
    public var properties: MetadataSectionProperties = .default
    
    func registerReusableTypes(tableView: UITableView) {
        tableView.register(MetadataRowItemCell.self, forCellReuseIdentifier: String(describing: MetadataRowItemCell.self))
        tableView.register(WalletSectionHeader.self, forHeaderFooterViewReuseIdentifier: String(describing: WalletSectionHeader.self))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return properties.items.count
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: WalletSectionHeader.self)) as? WalletSectionHeader else {
            return UIView()
        }
        header.title.text = properties.title
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    static func mapControllerFromProperties(_ properties: MetadataSectionProperties) -> MetadataTableSectionController {
        let controller = MetadataTableSectionController()
        controller.properties = properties
        return controller
    }
}
