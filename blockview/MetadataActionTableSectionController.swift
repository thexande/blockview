import UIKit

final class MetadataActionTableSectionController: NSObject, WalletTableSectionController {
    public var dispatcher: WalletDetailActionDispatching?
    public var properties: [MetadataActionRowItemProperties] = []
    var sectionTitle: String?
    
    func registerReusableTypes(tableView: UITableView) {
        tableView.register(ActionIconRowCell.self, forCellReuseIdentifier: String(describing: ActionIconRowCell.self))
        tableView.register(WalletSectionHeader.self, forHeaderFooterViewReuseIdentifier: String(describing: WalletSectionHeader.self))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ActionIconRowCell.self)) as? ActionIconRowCell else {
            return UITableViewCell()
        }
        cell.title = properties[indexPath.row].title
        cell.iconImage = properties[indexPath.row].icon
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: WalletSectionHeader.self)) as? WalletSectionHeader,
            let sectionTitle = sectionTitle
            else {
                return nil
        }
        
        header.textLabel?.text = sectionTitle
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dispatcher?.dispatch(properties[indexPath.row].action)
    }
    
    static func mapControllerFromProperties(_ properties: [MetadataActionRowItemProperties]) -> MetadataActionTableSectionController {
        let controller = MetadataActionTableSectionController()
        controller.properties = properties
        return controller
    }
}

