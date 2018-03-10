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
    case transactionSegment
}

/// Metadata Table row item view properties
protocol MetadataRowItemProperties {
    //    static var `default`: Self { get }
}

struct MetadataTitleRowItemProperties: MetadataRowItemProperties {
    let title: String
    let content: String
    static let `default` = MetadataTitleRowItemProperties(title: "", content: "")
}

struct MetadataAddressRowItemProperties: MetadataRowItemProperties {
    let address: String
    static let `default` = MetadataAddressRowItemProperties(address: "")
}

struct MetadataTransactionSegmentRowItemProperties: MetadataRowItemProperties {
    let address: String
    static let `default` = MetadataTransactionSegmentRowItemProperties(address: "")
}


/// Metadata Table row item view properties
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

struct MetadataAddressSectionProperties: MetadataSectionProperties {
    var displayStyle: MetadataRowDisplayStyle
    let title: String
    var items: [MetadataRowItemProperties]
    static let `default` = MetadataAddressSectionProperties(displayStyle: .address, title: "", items: [])
}

struct MetadataTransactionSegmentSectionProperties: MetadataSectionProperties {
    let displayStyle: MetadataRowDisplayStyle
    let title: String
    var items: [MetadataRowItemProperties]
    static let `default` = MetadataTransactionSegmentSectionProperties(displayStyle: .transactionSegment, title: "", items: [])
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
        let metadataSections = MetadataTableSectionHelper.mapControllerFromSections(properties.sections)
        let transactionSection = TransactionTableSectionController.mapController(from: [properties.transactionItemProperties])
        
        var sectionControllers: [TableSectionController] = []
        sectionControllers.append(transactionSection)
        sectionControllers.append(contentsOf: metadataSections)
        sections = sectionControllers
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.refreshControl?.endRefreshing()
        }
    }
}
