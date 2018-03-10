import UIKit

final class TransactionTableSectionController: NSObject, TableSectionController {
    var sectionTitle: String?
    
    public var properties: [TransactionRowItemProperties] = []
    
    func registerReusableTypes(tableView: UITableView) {
        tableView.register(WalletDetailRowItemCell.self, forCellReuseIdentifier: String(describing: WalletDetailRowItemCell.self))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WalletDetailRowItemCell.self), for: indexPath) as? WalletDetailRowItemCell else {
            return UITableViewCell()
        }
        cell.properties = properties[indexPath.row]
        return cell
    }
    
    static func mapController(from properties: [TransactionRowItemProperties]) -> TransactionTableSectionController {
        let controller = TransactionTableSectionController()
        controller.properties = properties
        return controller
    }
}
