import UIKit
import Anchorage

final class OnboardItemView: UIView {
    private let iconView = UIImageView()
    private let iconContainer = UIView()
    private let contentLabel = UILabel()
    
    struct Properties {
        let content: String
        let icon: UIImage?
    }
    
    func configure(_ properties: Properties) {
        iconView.image = properties.icon
        contentLabel.text = properties.content
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let stack = UIStackView(arrangedSubviews: [iconContainer, contentLabel])
        stack.spacing = 18
        iconView.sizeAnchors == CGSize(width: 52, height: 52)
        iconContainer.addSubview(iconView)
        iconView.edgeAnchors == iconContainer.edgeAnchors + UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        addSubview(stack)
        stack.edgeAnchors == edgeAnchors
        
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.numberOfLines = 0
        contentLabel.minimumScaleFactor = 0.5
        contentLabel.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class OnboardingInformationViewController: UIViewController {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let action = PrimaryButton()
    private let actionContainer = UIView()
    
    struct Properties {
        let title: String
        let subtitle: String
        let onboardingItems: [OnboardItemView.Properties]
    }
    
    func configure(_ properties: Properties) {
        titleLabel.text = properties.title
        subtitleLabel.text = properties.subtitle
        
        let onboardItemViews: [UIView] = properties.onboardingItems.map { props in
            let view = OnboardItemView()
            view.configure(props)
            return view
        }
        
        let onboardStack = UIStackView(arrangedSubviews: onboardItemViews)
        onboardStack.axis = .vertical
        onboardStack.spacing = 24
        
        actionContainer.addSubview(action)
        action.heightAnchor == 50
        action.setTitle("Continue", for: .normal)
        action.edgeAnchors == actionContainer.edgeAnchors + UIEdgeInsets(top: 36, left: 0, bottom: 0, right: 0)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, onboardStack, actionContainer])
        stack.axis = .vertical
        stack.spacing = 36
        
        view.addSubview(stack)
        stack.horizontalAnchors == view.horizontalAnchors + 48
        stack.verticalAnchors >= view.verticalAnchors + 32
        stack.centerYAnchor == view.centerYAnchor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        titleLabel.minimumScaleFactor = 0.35
        titleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.numberOfLines = 0
        
        configure(Properties(title: "Welcome to Block View", subtitle: "Great new tools for notes synced to your iCloud account.", onboardingItems: [
            OnboardItemView.Properties(content: "Capture documents, photos, maps and more for a richer Notes experience.", icon: UIImage(named: "copy_icon")),
            OnboardItemView.Properties(content: "Capture documents, photos, maps and more for a richer Notes experience.", icon: UIImage(named: "copy_icon")),
            OnboardItemView.Properties(content: "Capture documents, photos, maps and more for a richer Notes experience.", icon: UIImage(named: "copy_icon")),
            ]))
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let walletCoordinator = WalletCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().tintColor = StyleConstants.primaryPurple
        window?.tintColor = StyleConstants.primaryPurple

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = walletCoordinator.rootViewController
//        window?.rootViewController = OnboardingInformationViewController()
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

