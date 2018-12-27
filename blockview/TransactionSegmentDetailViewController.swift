import UIKit
import Anchorage

final class TransactionSegmentDetailViewController: SectionProxyTableViewController {
    weak var dispatcher: WalletDetailActionDispatching?
    
    struct Properties {
        let title: String
        let sections: [MetadataSectionProperties]
        static let `default` = Properties(title: "", sections: [])
        
        init(title: String,
             sections: [MetadataSectionProperties]) {
            self.title = title
            self.sections = sections
        }
        
        init(_ input: Input) {
            var sections: [MetadataSectionProperties] = []
            
            let metadataItems = [
                MetadataTitleRowItemProperties(title: "Previous Hash", content: input.prev_hash),
                MetadataTitleRowItemProperties(title: "Output Index", content: String(input.output_index)),
                MetadataTitleRowItemProperties(title: "Output Value", content: String(input.output_value)),
                MetadataTitleRowItemProperties(title: "Script", content: input.script),
                MetadataTitleRowItemProperties(title: "Sequence", content: String(input.sequence)),
                MetadataTitleRowItemProperties(title: "Age", content: String(input.age)),
            ]
            
            sections.append(MetadataTitleSectionProperties(displayStyle: .metadata,
                                                           title: "Metadata",
                                                           items: metadataItems))
            
            if let addresses = input.addresses {
                let addressItems = addresses.map { address in
                    return MetadataTransactionSegmentRowItemProperties(address: address)

                }
                
                sections.append(MetadataAddressSectionProperties(displayStyle: .metadata,
                                                                 title: "Addresses",
                                                                 items: addressItems))
            }
            
            self.sections = sections
            self.title = "Input"
        }
        
        init(_ output: Output) {
            var sections: [MetadataSectionProperties] = []
            
            let metadataItems = [
                MetadataTitleRowItemProperties(title: "Value", content: output.value.satoshiToReadableBtc()),
                MetadataTitleRowItemProperties(title: "Script", content: output.script),
                MetadataTitleRowItemProperties(title: "Script Type", content: output.script_type)
                ]
            
            sections.append(MetadataTitleSectionProperties(displayStyle: .metadata,
                                                           title: "Metadata",
                                                           items: metadataItems))
            let addressItems = output.addresses.map { address in
                return MetadataTransactionSegmentRowItemProperties(address: address)
            }
            
            sections.append(MetadataAddressSectionProperties(displayStyle: .metadata,
                                                             title: "Addresses",
                                                             items: addressItems))
            
            self.sections = sections
            self.title = "Output"
        }
    }
    
    override var sections: [WalletTableSectionController] {
        didSet {
            self.sections.forEach { $0.registerReusableTypes(tableView: self.tableView) }
        }
    }
    
    func render(_ properties: Properties) {
        DispatchQueue.main.async {
            self.title = properties.title
            self.sections = MetadataTableSectionFactory.mapControllerFromSections(properties.sections, dispatcher: self.dispatcher)
            self.tableView.reloadData()
        }
    }
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
    }
}
