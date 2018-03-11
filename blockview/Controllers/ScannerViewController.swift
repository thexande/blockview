import AVFoundation
import UIKit
import Anchorage

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    fileprivate let icon = UIImageView()
    fileprivate let overlayLabel = UILabel()
    fileprivate let overlay = UIView()
    let headerView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    public var success: ((String, WalletType?) -> Void)?
    public var walletType: WalletType? {
        didSet {
            icon.image = walletType?.icon
            overlayLabel.text = "Scan your \(walletType?.symbol ?? "") wallet address."
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        
        let targetLayer = CALayer()
        let targetImage = #imageLiteral(resourceName: "qr_box_white").withRenderingMode(.alwaysTemplate)
        targetLayer.frame = CGRect(x: view.frame.midX - 100, y: view.frame.midY - 100, width: 200, height: 200)
        
        targetLayer.contents = targetImage.cgImage
        
        previewLayer.addSublayer(targetLayer)
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
     
        overlayLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        overlayLabel.textAlignment = .center
     
        
        overlay.backgroundColor = .clear
        view.addSubview(overlay)
        overlay.topAnchor == view.safeAreaLayoutGuide.topAnchor
        overlay.bottomAnchor == view.safeAreaLayoutGuide.bottomAnchor
        overlay.horizontalAnchors == view.horizontalAnchors
        
        overlay.addSubview(headerView)
        
        headerView.horizontalAnchors == overlay.horizontalAnchors
        headerView.topAnchor == view.topAnchor
        headerView.heightAnchor == 140
        
        headerView.contentView.addSubview(icon)
        icon.sizeAnchors == CGSize(width: 60, height: 60)
        icon.centerXAnchor == headerView.centerXAnchor
        icon.topAnchor == headerView.topAnchor + 36
        
        headerView.contentView.addSubview(overlayLabel)
        overlayLabel.horizontalAnchors == headerView.horizontalAnchors + 24
        overlayLabel.topAnchor == icon.bottomAnchor + 12
        
        
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        success?(code, walletType)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
