import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let walletCoordinator = WalletCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().tintColor = StyleConstants.primaryPurple
        window?.tintColor = StyleConstants.primaryPurple

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = walletCoordinator.rootViewController
//        window?.rootViewController = OnboardingInformationViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
}

