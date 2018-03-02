import Foundation
import UIKit
//import RealmSwift

class RootTabViewController: UITabBarController {
    let tabOneItem: UIViewController = {
        let vc = UINavigationController(rootViewController: MyWalletsViewController())
        let icon = UIImage() //FontAwesomeHelper.iconToImage(icon: FontAwesome.lineChart, color: .black, width: 35, height: 35)
        let item = UITabBarItem(title: "my wallets".uppercased(), image: icon, selectedImage: icon)
        vc.navigationBar.prefersLargeTitles = true
        vc.navigationItem.largeTitleDisplayMode = .always
        vc.tabBarItem = item
        return vc
    }()
    
    let tabTwoItem: UIViewController = {
        let vc = UINavigationController(rootViewController: ExploreViewController())
        let icon = UIImage() //FontAwesomeHelper.iconToImage(icon: FontAwesome.dollar, color: .black, width: 35, height: 35)
        let item = UITabBarItem(title: "explore".uppercased(), image: icon, selectedImage: icon)
        vc.navigationBar.prefersLargeTitles = true
        vc.navigationItem.largeTitleDisplayMode = .always
        vc.tabBarItem = item
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.tabBar.backgroundColor = StyleConstants.color.primary_red
        //        self.tabBar.tintColor = .white
        self.viewControllers = [tabOneItem, tabTwoItem]
        
//        do {
//            let realm = try Realm()
//            debugPrint("Path to realm file: " + realm.configuration.fileURL?.absoluteString ?? "")
//        } catch let error {
//            print(error.localizedDescription)
//        }
    }
}
