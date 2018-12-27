import UIKit
import Anchorage

final class OnboardingInformationViewController: UIViewController {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let action = PrimaryButton()
    private let actionContainer = UIView()
    weak var dispatcher: WalletActionDispatching?
    
    struct Properties {
        let title: NSAttributedString
        let subtitle: String
        let onboardingItems: [OnboardItemView.Properties]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        titleLabel.numberOfLines = 0
        titleLabel.minimumScaleFactor = 0.35
        titleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.numberOfLines = 0
        configure(makeOnboardingProperties())
        
        action.addAction { [weak self] in
            self?.dispatcher?.dispatch(.dismissOnboarding)
        }
    }
    
    func configure(_ properties: Properties) {
        titleLabel.attributedText = properties.title
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
    
    private func makeOnboardingProperties() -> Properties {
        let attributedTitle = NSMutableAttributedString()
        
        let prefixAttributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 42, weight: .black),
            NSAttributedString.Key.foregroundColor : UIColor.black
        ]
        
        let titleAttributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 42, weight: .black),
            NSAttributedString.Key.foregroundColor : StyleConstants.primaryPurple
        ]
        
        let prefix = NSMutableAttributedString(string:"Welcome to ", attributes: prefixAttributes)
        
        let title = NSMutableAttributedString(string:"Block Viewer", attributes: titleAttributes)
        
        [prefix, title].forEach { string in
            attributedTitle.append(string)
        }
        
        return OnboardingInformationViewController.Properties(title: attributedTitle, subtitle: "Great tools for viewing blockchain transaction metadata.", onboardingItems: [
            OnboardItemView.Properties(content: "Verify successful transactions through confirmation counts and block indexes.", icon: UIImage(named: "lock")),
            OnboardItemView.Properties(content: "Scan QR codes to view transactions associated with a wallet, or display a wallet's QR code for payment.", icon: UIImage(named: "qrsvg")),
            OnboardItemView.Properties(content: "Currently, only Bitcoin is supported. Multi currency wallet support is in development.", icon: UIImage(named: "multi_currency")),
        ])
    }
}
