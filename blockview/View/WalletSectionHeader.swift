import UIKit
import Anchorage

final class WalletSectionHeader: UITableViewHeaderFooterView {
    let title = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(title)
        title.leadingAnchor == contentView.leadingAnchor + 12
        title.centerYAnchor == contentView.centerYAnchor
        title.font = UIFont.systemFont(ofSize: 17)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
