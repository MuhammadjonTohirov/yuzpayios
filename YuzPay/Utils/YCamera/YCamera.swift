//
//  YCamera.swift
//  YuzPay
//
//  Created by applebro on 08/01/23.
//

import Foundation
import AVKit
import UIKit
import SwiftUI

struct YCamera: UIViewRepresentable {
    
    typealias UIViewType = UIView
    let manager = YCameraManager()
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .systemBlue
        DispatchQueue.global(qos: .background).async {
            self.manager.config()
            self.manager.start()
        }
        
        self.manager.setupLayerWith(view: view)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

struct YCamera_Preview: PreviewProvider {
    static var previews: some View {
        YCamera()
    }
}

final class YCameraManager: NSObject {
    let session = AVCaptureSession()
    var captureDevice: AVCaptureDeviceInput?
    var photoOutput: AVCapturePhotoOutput?
    var layer: AVCaptureVideoPreviewLayer?
    override init() {
        super.init()
    }
    
    func config() {
        guard let defaultVideoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            return
        }
        
        do {
            self.captureDevice = try .init(device: defaultVideoDevice)
            
            self.photoOutput = AVCapturePhotoOutput()
        } catch {
            Logging.l("Cannot create video capture device")
        }
        
        if let videoInput = self.captureDevice, session.canAddInput(videoInput) {
            session.addInput(videoInput)
        }
        
        if let photoOutput = self.photoOutput, session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }
    }
    
    func setupLayerWith(view: UIView) {
        self.layer = AVCaptureVideoPreviewLayer(session: session)
        self.layer?.backgroundColor = UIColor.systemRed.cgColor
        view.layer.addSublayer(layer!)
    }
    
    func capture() {
        photoOutput?.capturePhoto(with: .init(rawPixelFormatType: .max), delegate: self)
    }
    
    func start() {
        session.startRunning()
    }
    
    func stop() {
        session.stopRunning()
    }
}

extension YCameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        
    }
}
