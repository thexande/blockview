import UIKit
import Anchorage
import Lottie

final class WalletsEmptyStateView: UIView {
    let animation = LOTAnimationView(name: "qr_animation")
    let actionButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(animation)
        animation.sizeAnchors == CGSize(width: 200, height: 200)
        animation.centerXAnchor == centerXAnchor
        animation.centerYAnchor == centerYAnchor - 100
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

