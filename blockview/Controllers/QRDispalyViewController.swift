import UIKit
import Anchorage
import QRCode

final class QRDispalyViewController: UIViewController {
    let image = UIImageView()
    
    public var address: String = "" {
        didSet {
            let qrCode = QRCode("http://schuch.me")
            image.image = qrCode?.image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(image)
        image.widthAnchor == view.widthAnchor - 24
        image.heightAnchor == image.widthAnchor
        image.centerAnchors == view.centerAnchors
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(done))
    }
    
    @objc func done() {
        dismiss(animated: true, completion: nil)
    }
}
