import UIKit

final class ExploreViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Explorer"
    }
}

final class CryptoCard: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
