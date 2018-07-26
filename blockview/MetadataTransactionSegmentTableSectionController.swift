import UIKit

final class MetadataTransactionSegmentTableSectionController: NSObject, WalletTableSectionController {
    public var dispatcher: WalletDetailActionDispatching?
    public var properties: [MetadataTransactionSegmentRowItemProperties] = []
    var sectionTitle: String?
    var context: WalletDetailAcitons.Context?
    
    func registerReusableTypes(tableView: UITableView) {
        tableView.register(MetadataTransactionSegmentRowItemCell.self, forCellReuseIdentifier: String(describing: MetadataTransactionSegmentRowItemCell.self))
        tableView.register(WalletSectionHeader.self, forHeaderFooterViewReuseIdentifier: String(describing: WalletSectionHeader.self))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MetadataTransactionSegmentRowItemCell.self)) as? MetadataTransactionSegmentRowItemCell else {
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
        if let context = context {
            switch context {
            case .wallet: break
            case let .transaction(context):
                switch context {
                case .input:
                    dispatcher?.dispatch(.selectedInput(properties[indexPath.row].address))
                case .output:
                    dispatcher?.dispatch(.selectedOutput(properties[indexPath.row].address))
                }   
            }
        }
    }
    
    static func mapControllerFromProperties(_ properties: [MetadataTitleRowItemProperties]) -> MetadataTitleTableSectionController {
        let controller = MetadataTitleTableSectionController()
        controller.properties = properties
        return controller
    }
}

