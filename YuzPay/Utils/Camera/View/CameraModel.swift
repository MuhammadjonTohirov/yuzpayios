//
//  CameraService.swift
//  YuzPay
//
//  Created by applebro on 08/01/23.
//

import Foundation
import AVKit
import Combine

final class CameraModel: ObservableObject {
    private(set) var service: CameraService!
    
    @Published var photo: Photo?
    
    @Published var showAlertError = false
    
    @Published var isFlashOn = false
    
    @Published var willCapturePhoto = false
    
    var alertError: AlertError!
    
    var session: AVCaptureSession
    
    private var subscriptions = Set<AnyCancellable>()
    
    var onCapture: ((URL?) -> Void)?
    
    var onStartCapture: (() -> Void)?
    
    var onStartRecording: (() -> Void)?
    
    var onEndRecording: ((Video?) -> Void)?
    
    init(_ cameraPosition: AVCaptureDevice.Position = .back) {
        self.service = CameraService(preferredCameraPosition: cameraPosition)
        self.session = service.session
        
        service.$photo.sink { [weak self] (photo) in
            guard let pic = photo else { return }
            self?.photo = pic
            // save photo to gallery
            if let image = pic.image, let url = self?.service.savePhotoToGallery(image) {
                self?.onCapture?(url)
            }
        }
        .store(in: &self.subscriptions)
        
        service.$shouldShowAlertView.sink { [weak self] (val) in
            self?.alertError = self?.service.alertError
            self?.showAlertError = val
        }
        .store(in: &self.subscriptions)
        
        service.$flashMode.sink { [weak self] (mode) in
            self?.isFlashOn = mode == .on
        }
        .store(in: &self.subscriptions)
        
        service.$willCapturePhoto.sink { [weak self] (val) in
            self?.willCapturePhoto = val
        }
        .store(in: &self.subscriptions)
        
        service.$isRecording.sink { [weak self] isRecording in
            guard let self else {
                return
            }
            if isRecording && self.service.video == nil {
                self.onStartRecording?()
            }
            
            if !isRecording, let url = self.service.video {
                self.onEndRecording?(url)
            }
            
            #if DEBUG
            if let url = self.service.video, !isRecording {
                service.saveVideoToGallery(url.videoUrl)
            }
            #endif
        }
        .store(in: &self.subscriptions)
    }
    
    func configure() {
        service.checkForPermissions()
        service.configure()
    }
    
    func capturePhoto() {
        self.onStartCapture?()
        service.capturePhoto()
    }
    
    func startRecording() {
        service.startRecording()
    }
    
    func stopRecording() {
        service.stopRecording()
    }
    
    func startRunning() {
        DispatchQueue.global(qos: .background).async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }
    
    func stopRunning() {
        DispatchQueue.global(qos: .background).async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
    
    func flipCamera(_ position: AVCaptureDevice.Position? = nil) {
        self.service.changeCamera(toPosition: position ?? .back)
    }
    
    func zoom(with factor: CGFloat) {
        service.set(zoom: factor)
    }
    
    func switchFlash(_ mode: AVCaptureDevice.FlashMode? = nil) {
        service.flashMode = mode ?? (service.flashMode == .on ? .off : .on)
    }
}
