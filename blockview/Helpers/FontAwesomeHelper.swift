import Foundation
import UIKit
import FontAwesome_swift

class FontAwesomeHelper {
    static func iconToImage(icon: FontAwesome, color: UIColor, width: Int, height: Int) -> UIImage {
        return UIImage.fontAwesomeIcon(name: icon, textColor: color, size: CGSize(width: width, height: height))
    }
}
