import UIKit
import Anchorage

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
