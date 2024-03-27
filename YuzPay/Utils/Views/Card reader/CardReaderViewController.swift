//
//  CardReaderViewController.swift
//  YuzPay
//
//  Created by applebro on 27/12/22.
//

import UIKit

final class CardReaderViewController: UIViewController {
    var cameraAccess: CameraAccessProtocol?
    var scanner: CardScanner?
    var stream: PixelBufferStream?

    var cardNumber: String = ""
    var expireDate: String = ""
    
    private var hasValidValue: Bool = false
    private let closeView = UIImageView()
    
    var onSuccess: ((_ number: String, _ date: String) -> Void)?
    var onDismiss: (() -> Void)?
    
    private lazy var overlay: UIImageView = UIImageView(image: UIImage(named: "overlay"))
    private lazy var cardArea: UIImageView = UIImageView(image: UIImage(named: "image_area"))
    
    private let infoLabel = UILabel()
    
    private let cardInfoLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraAccess = CameraAccess()
        scanner = CardScanner()
        stream = CameraPixelBufferStream()
        
        self.view.addSubview(self.stream!.previewView)
        self.view.addSubview(closeView)
        self.view.addSubview(overlay)
        self.view.addSubview(cardArea)
        self.view.addSubview(infoLabel)
        self.view.addSubview(cardInfoLabel)
        
        cardArea.contentMode = .scaleAspectFit
        overlay.contentMode = .scaleToFill
        closeView.image = UIImage(named: "icon_x")?.withTintColor(.white)
        closeView.tintColor = .white
        closeView.onClick(self, #selector(onClickDismissAction))
        
        infoLabel.text = "focus_camera_to_card".localize
        infoLabel.textColor = .white
        infoLabel.font = UIFont.mont(.semibold, size: 20)
        infoLabel.textAlignment = .center
        
        cardInfoLabel.alpha = 0
        cardInfoLabel.textColor = .white
        cardInfoLabel.numberOfLines = 2
        cardInfoLabel.font = UIFont.mont(.semibold, size: 20)
        cardInfoLabel.textAlignment = .left
        cardInfoLabel.contentMode = .bottomLeft
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startCamera()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.stream?.previewView.frame = self.view.bounds
        self.closeView.frame = .init(x: 24, y: UIApplication.shared.safeArea.top + 24, width: 24, height: 24)
        self.overlay.frame = self.view.bounds
        self.cardArea.center = self.view.center
        self.cardArea.frame.size = .init(width: 240.f.sw() * 1.582, height: 240.f.sw())
        
        var x: CGFloat = 24
        var w: CGFloat = view.frame.width - 2 * x
        
        var y: CGFloat = cardArea.frame.maxY + 48.f.sw()
        var h: CGFloat = 30
        
        self.infoLabel.frame = .init(x: x, y: y, width: w, height: h)
        
        x = cardArea.frame.minX + 20
        h = 80
        y = cardArea.frame.maxY - h - 20
        w = cardArea.frame.width - 40
        self.cardInfoLabel.frame = .init(x: x, y: y, width: w, height: h)
        
        self.view.bringSubviewToFront(self.overlay)
        self.view.bringSubviewToFront(self.cardArea)
        self.view.bringSubviewToFront(self.closeView)
        self.view.bringSubviewToFront(self.infoLabel)
        self.view.bringSubviewToFront(self.cardInfoLabel)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopCamera()
    }
    
    func startCamera() {
        if stream == nil {
            scanner = CardScanner()
            stream = CameraPixelBufferStream()
        }
        
        cameraAccess?.request { [weak self] success in
            success ? self?.onHaveCamera() : ()
        }
    }
    
    func stopCamera() {
        scanner?.reset()
        stream?.running = false
    }
    
    private func onHaveCamera() {
        self.view.setNeedsLayout()
        stream?.running = true
        stream?.layoutSubviews()
        self.view.setNeedsLayout()
        if let buffer = scanner?.read(buffer:orientation:) {
            stream?.output = buffer
        }

        scanner?.regionOfInterest = UIScreen.screen
        
        scanner?.output = { [weak self] response in
            DispatchQueue.main.async {
                guard let self else {
                    return
                }

                if self.hasValidValue {
                    return
                }
                
                self.cardNumber = response?.number ?? ""
                self.expireDate = response?.expiry ?? ""
                
                if !self.cardNumber.isEmpty && !self.expireDate.isEmpty {
                    self.hasValidValue = true
                    print(self.cardNumber, self.expireDate)
                    self.reloadCardInfoLabel()
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                        self.scanner?.reset()
                        self.stream?.running = false
                        self.scanner = nil
                        self.stream = nil
                        self.onSuccess?(self.cardNumber, self.expireDate)
                    }
                }
            }
        }
    }
    
    func reloadCardInfoLabel() {
        self.cardInfoLabel.alpha = 1
        self.cardInfoLabel.text = "\(cardNumber)\n\(expireDate)"
    }
    
    @objc private func onClickDismissAction() {
        onDismiss?()
    }
}
