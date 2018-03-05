import UIKit
import Anchorage

protocol TableSectionController: UITableViewDelegate, UITableViewDataSource {
    func registerReusableTypes(tableView: UITableView)
}

protocol CollectionSectionController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func registerReusableTypes(collectionView: UICollectionView)
}

struct MetadataRowItemProperties {
    let title: String
    let content: String
    static let `default` = MetadataRowItemProperties(title: "", content: "")
}

struct MetadataSectionProperties {
    let title: String
    let items: [MetadataRowItemProperties]
    static let `default` = MetadataSectionProperties(title: "", items: [])
}

struct TransactionDetailViewProperties {
    let title: String
    let transactionItemProperties: TransactionRowItemProperties
    let sections: [MetadataSectionProperties]
    static let `default` = TransactionDetailViewProperties(title: "", transactionItemProperties: .default, sections: [])
}

final class TransactionDetailViewController: UITableViewController, ViewPropertiesUpdating {
    fileprivate var sections: [TableSectionController] = [] {
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (sections[section].tableView?(tableView, heightForHeaderInSection: section)) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections[section].tableView?(tableView, viewForHeaderInSection: section)
    }
}
