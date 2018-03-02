import UIKit
import Lottie
import Anchorage

final class MyWalletsViewController: UIViewController {
    let emptyState = EmptyStateView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Wallets"
        
        view.addSubview(emptyState)
        emptyState.edgeAnchors == view.edgeAnchors
        emptyState.actionButton.addTarget(self, action: #selector(scanTapped), for: .touchUpInside)
    }
    
    
    @objc func scanTapped() {
        present(ScannerViewController(), animated: true, completion: nil)
    }
}


final class EmptyStateView: UIView {
    let animation = LOTAnimationView(name: "qr_animation")
    let actionButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(animation)
        animation.sizeAnchors == CGSize(width: 200, height: 200)
        animation.centerAnchors == centerAnchors
        animation.loopAnimation = true
        animation.play()
        
        addSubview(actionButton)
        actionButton.horizontalAnchors == horizontalAnchors + 12
        actionButton.heightAnchor == 48
        actionButton.topAnchor == animation.bottomAnchor + 36
        
        actionButton.setTitle("Scan Wallet QR", for: .normal)
        actionButton.backgroundColor = .black
        actionButton.layer.cornerRadius = 6
        actionButton.tintColor = .gray
        
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
