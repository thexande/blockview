import UIKit
import Anchorage

final class WalletSectionHeader: UITableViewHeaderFooterView {
    let title = UILabel()
    let background = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        backgroundView?.backgroundColor = .clear
        
        contentView.addSubview(background)
        background.edgeAnchors == contentView.edgeAnchors
        contentView.addSubview(title)
        title.leadingAnchor == contentView.leadingAnchor + 12
        title.centerYAnchor == contentView.centerYAnchor
        title.font = UIFont.systemFont(ofSize: 17)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
