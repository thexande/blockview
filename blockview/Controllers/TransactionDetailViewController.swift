import UIKit
import Anchorage

protocol TableSectionController: UITableViewDelegate, UITableViewDataSource {
    var sectionTitle: String? { get }
    func registerReusableTypes(tableView: UITableView)
}

protocol CollectionSectionController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func registerReusableTypes(collectionView: UICollectionView)
}

enum MetadataRowDisplayStyle {
    case metadata
    case address
}

struct MetadataTitleRowItemProperties: MetadataRowItemProperties {
    let title: String
    let content: String
    static let `default` = MetadataTitleRowItemProperties(title: "", content: "")
}

protocol MetadataRowItemProperties {
//    static var `default`: Self { get }
}

protocol MetadataSectionProperties {
    var displayStyle: MetadataRowDisplayStyle { get }
    var title: String { get }
    var items: [MetadataRowItemProperties] { get }
}

struct MetadataTitleSectionProperties: MetadataSectionProperties {
    let displayStyle: MetadataRowDisplayStyle
    let title: String
    let items: [MetadataRowItemProperties]
    static let `default` = MetadataTitleSectionProperties(displayStyle: .address, title: "", items: [])
}

struct TransactionDetailViewProperties {
    let title: String
    let transactionItemProperties: TransactionRowItemProperties
    let sections: [MetadataSectionProperties]
    static let `default` = TransactionDetailViewProperties(title: "", transactionItemProperties: .default, sections: [])
}

final class TransactionDetailViewController: SectionProxyTableViewController, ViewPropertiesUpdating {
    override var sections: [TableSectionController] {
        didSet {
            sections.forEach { $0.registerReusableTypes(tableView: tableView) }
            tableView.reloadData()
        }
    }
    
    public var properties: TransactionDetailViewProperties = .default {
        didSet {
            update(properties)
        }
    }
    
    func update(_ properties: TransactionDetailViewProperties) {
        title = properties.title
        let metadataSections: [TableSectionController] = properties.sections.map(MetadataTableSectionController.mapControllerFromProperties(_:))
        let transactionSection = TransactionTableSectionController.mapController(from: [properties.transactionItemProperties])
        
        var sectionControllers: [TableSectionController] = []
        sectionControllers.append(transactionSection)
        sectionControllers.append(contentsOf: metadataSections)
        sections = sectionControllers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}
